{
* stones.pas
* Программа для решения задач с камнями.
}
{$ModeSwitch nestedprocvars}
uses sysutils;

const
	limit = 3; // до какого уровня спуск
	moves = 4; // сколько возможных ходов есть (обычно кол-во куч*кол-во операций)
	win = 38; // больше чего побеждаем	
	bh_0 = 7; // начальное камней в 1 куче
	bh_1 = 14; // начальное камней во 2 куче
	plus = 1; // прибавляем
	mul = 2; // умножаем
	vertical = false; // вертикально расположить граф тру/фолс

type
	Ttree = ^Ttree_n;
	Ttree_n = record
		level: integer;
		heap_0, heap_1: integer;
		next: array [1..moves] of Ttree;
	end;

function is_winner(gameTree: Ttree): boolean;
begin
	if gameTree^.heap_0 + gameTree^.heap_1 >= win then
		exit(true);
	exit(false);
end;

procedure game(gameTree: Ttree);
var
	n: integer; // эта переменная нужна для того, чтобы следить за номером хода
begin
	gameTree^.next[1] := nil;
	{проверка на выигрышную позицию}
	if is_winner(gameTree) then
		exit();
	{проверка на поколение}
	if gameTree^.level >= limit then
		exit();
	{генерируем ходы}
	{пример хода, у него номер 0. потом будет 1, 2...}
	n := 1;
	new(gameTree^.next[n]);
	gameTree^.next[n]^.level := gameTree^.level + 1; // не трогаем
	gameTree^.next[n]^.heap_0 := gameTree^.heap_0 + plus;
	gameTree^.next[n]^.heap_1 := gameTree^.heap_1;
	game(gameTree^.next[n]); // подпроцедуру запускаем с этим ходом
	{конец примера}
	{пример хода, у него номер 1}
	n := 2;
	new(gameTree^.next[n]);
	gameTree^.next[n]^.level := gameTree^.level + 1; // не трогаем
	gameTree^.next[n]^.heap_0 := gameTree^.heap_0;
	gameTree^.next[n]^.heap_1 := gameTree^.heap_1 + plus;
	game(gameTree^.next[n]); // подпроцедуру запускаем с этим ходом
	{конец примера}
	n := 3;
	new(gameTree^.next[n]);
	gameTree^.next[n]^.level := gameTree^.level + 1; // не трогаем
	gameTree^.next[n]^.heap_0 := gameTree^.heap_0 * mul;
	gameTree^.next[n]^.heap_1 := gameTree^.heap_1;
	game(gameTree^.next[n]); // подпроцедуру запускаем с этим ходом
	{конец примера}
	{пример хода, у него номер 1}
	n := 4;
	new(gameTree^.next[n]);
	gameTree^.next[n]^.level := gameTree^.level + 1; // не трогаем
	gameTree^.next[n]^.heap_0 := gameTree^.heap_0;
	gameTree^.next[n]^.heap_1 := gameTree^.heap_1 * mul;
	game(gameTree^.next[n]); // подпроцедуру запускаем с этим ходом
	{конец примера}
end;

function format_val(gameTree: Ttree): string;
var
	s: string;
begin
	s := format('(%d, %d)', [gameTree^.heap_0, gameTree^.heap_1]);
	exit(s);
end;

procedure display(gameTree: Ttree);
var
	gameBegin: Ttree;
	procedure print_vertices(name:string; tree:Ttree);
	var 
		i: integer;
	begin
		if tree^.next[1] = nil then
			exit();
		for i := 1 to moves do
		begin
			write(#9, name+format('%d', [i]), ' [label="', format_val(tree^.next[i]) ,'"');
			if is_winner(tree^.next[i]) then
				write(' fillcolor=red');
			writeln(']', ';');
			print_vertices(name+format('%d', [i]), tree^.next[i])
		end;
	end;
	procedure print_edges(name:string; tree:Ttree);
	var 
		i: integer;
	begin
		if tree^.next[1] = nil then
			exit();
		for i := 1 to moves do
		begin
			writeln(#9, name, ' -> ', name+format('%d', [i]), ';');
			print_edges(name+format('%d', [i]), tree^.next[i]);
		end;
	end;
begin
	gameBegin := gameTree;
	writeln('digraph game {');
	if vertical = true then	
		writeln(#9, 'rankdir="LR";');
	writeln(#9, 'node [style=filled];');
	writeln(#9, 'V_0', ' [label="', format_val(gameTree) ,'"]', ';');
	print_vertices('V_0', gameBegin);
	writeln();
	print_edges('V_0', gameBegin);
	writeln('}');
end;

var
	gameTree: Ttree;
begin
	{инициализация дерева}
	new(gameTree);
	gameTree^.level := 0;
	gameTree^.heap_0 := bh_0;
	gameTree^.heap_1 := bh_1;
	gameTree^.next[1] := nil;
	{конец инициализации}
	
	{играем}
	game(gameTree);
	
	{вывод}
	display(gameTree);
	
end.
