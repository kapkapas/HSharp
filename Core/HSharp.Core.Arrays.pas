unit HSharp.Core.Arrays;

interface

type
  TForEachProc<T> = reference to procedure (const AItem: T);
  TForEachProcIndex<T> = reference to procedure (const AItem: T; AIndex: Integer);
  TMapFunc<T> = reference to function (const AItem: T): T;
  TMapFuncIndex<T> = reference to function (const AItem: T; AIndex: Integer): T;
  TReduceFunc<T> = reference to function (const ALeft, ARight: T): T;
  TSortFunc<T> = reference to function (const ALeft, ARight: T): Integer;

  TArray<T> = record
  strict private
    FItems: System.TArray<T>;
    function GetItem(AIndex: Integer): T;
    procedure SetItem(AIndex: Integer; const AValue: T);
    procedure Swap(var ALeft, ARight: T);
  public
    procedure Add(AItem: T);
    procedure AddRange(AItems: array of T);
    function Clone: TArray<T>;
    function Count: Integer;
    class function Create(aArray: System.TArray<T>): TArray<T>; static;
    function First: T;
    procedure ForEach(AForEachProc: TForEachProc<T>);
    procedure ForEachIndex(AForEachProcIndex: TForEachProcIndex<T>);
    function Head: T;
    function Init: TArray<T>;
    property Items[AIndex: Integer]: T read GetItem write SetItem;
    function Last: T;
    function Length: Integer;
    procedure Map(AMapFunc: TMapFunc<T>);
    procedure MapIndex(AMapFuncIndex: TMapFuncIndex<T>);
    function Reduce(AReduceFunc: TReduceFunc<T>): T;
    function Remove(AIndex: Integer): T;
    function Reverse: TArray<T>;
    procedure Sort(ASortFunc: TSortFunc<T>; AReverse: Boolean = False);
    function Sorted(ASortFunc: TSortFunc<T>; AReverse: Boolean = False): TArray<T>;
    function Tail: TArray<T>;
  end;

implementation

{ TArray<T> }

procedure TArray<T>.Add(AItem: T);
begin
  SetLength(FItems, System.Length(FItems) + 1);
  FItems[High(FItems)] := AItem;
end;

procedure TArray<T>.AddRange(AItems: array of T);
var
  Item: T;
begin
  for Item in AItems do
    Add(Item);
end;

function TArray<T>.Clone: TArray<T>;
var
  Item: T;
begin
  for Item in FItems do
    Result.Add(Item);
end;

function TArray<T>.Count: Integer;
begin
  Result := Length;
end;

class function TArray<T>.Create(aArray: System.TArray<T>): TArray<T>;
begin
  Result.FItems := aArray;
end;

function TArray<T>.First: T;
begin
  Result := Head;
end;

procedure TArray<T>.ForEach(AForEachProc: TForEachProc<T>);
var
  Item: T;
begin
  for Item in FItems do
    AForEachProc(Item);
end;

procedure TArray<T>.ForEachIndex(AForEachProcIndex: TForEachProcIndex<T>);
var
  i: Integer;
begin
  for i := Low(FItems) to High(FItems) do
    AForEachProcIndex(FItems[i], i);
end;

function TArray<T>.GetItem(AIndex: Integer): T;
begin
  Result := FItems[AIndex];
end;

function TArray<T>.Head: T;
begin
  Result := FItems[0];
end;

function TArray<T>.Init: TArray<T>;
begin
  Result := Clone;
  Result.Remove(Count - 1);
end;

function TArray<T>.Last: T;
begin
  Result := FItems[High(FItems)];
end;

function TArray<T>.Length: Integer;
begin
  Result := High(FItems) + 1;
end;

procedure TArray<T>.Map(AMapFunc: TMapFunc<T>);
var
  i: Integer;
begin
  for i := Low(FItems) to High(FItems) do
    FItems[i] := AMapFunc(FItems[i]);
end;

procedure TArray<T>.MapIndex(AMapFuncIndex: TMapFuncIndex<T>);
var
  i: Integer;
begin
  for i := Low(FItems) to High(FItems) do
    FItems[i] := AMapFuncIndex(FItems[i], i);
end;

function TArray<T>.Reduce(AReduceFunc: TReduceFunc<T>): T;
var
  I: Integer;
begin
  Result := Head;
  for i := Low(FItems) + 1 to High(FItems) do
    Result := AReduceFunc(Result, FItems[i]);
end;

function TArray<T>.Remove(AIndex: Integer): T;
var
  Current: T;
  i: Integer;
begin
  Result := GetItem(AIndex);
  for i := AIndex to High(FItems) - 1 do
    FItems[i] := FItems[i + 1];
  SetLength(FItems, System.Length(FItems) - 1);
end;

function TArray<T>.Reverse: TArray<T>;
var
  i: Integer;
begin
  for i := High(FItems) downto Low(FItems) do
    Result.Add(FItems[i]);
end;

procedure TArray<T>.SetItem(AIndex: Integer; const AValue: T);
begin
  FItems[AIndex] := AValue;
end;

procedure TArray<T>.Sort(ASortFunc: TSortFunc<T>; AReverse: Boolean);
var
  I: Integer;
  SortResult: Integer;
begin
  for i := Low(FItems) to High(FItems) - 1 do
  begin
    SortResult := ASortFunc(FItems[i], FItems[i + 1]);
    if SortResult <> 0 then
    begin
      if SortResult > 0 then
        Swap(FItems[i], FItems[i + 1]);
    end;
  end;
  if AReverse then
    Reverse;
end;

function TArray<T>.Sorted(ASortFunc: TSortFunc<T>; AReverse: Boolean): TArray<T>;
begin
  Result := Clone;
  Result.Sort(ASortFunc, AReverse);
end;

procedure TArray<T>.Swap(var ALeft, ARight: T);
var
  Temp: T;
begin
  Temp   := ALeft;
  ALeft  := ARight;
  ARight := Temp;
end;

function TArray<T>.Tail: TArray<T>;
begin
  Result := Clone;
  Result.Remove(0);
end;

end.