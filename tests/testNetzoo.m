% Tell if this is Octave (Unit tests) or Matlab
isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;

% Load statistics package from Octave
if isOctave
	pkg install -forge io
	pkg install -forge statistics
	pkg load statistics
end

% Set Program Parameters
exp_file   = 'expression.txt';
motif_file = 'motif.txt';
ppi_file   = 'ppi.txt';
panda_out  = 'tmp/panda.test.txt';  % optional, leave empty if file output is not required
save_temp  = '';  % optional, leave empty if temp data files will not be needed afterward
lib_path   = '../netzoo-m';  % path to the folder of PANDA source code
alpha      = 0.1;
save_pairs = 0;%saving in .pairs format

% Add path
addpath(genpath(fullfile(pwd,'../netzoo-m')));

% Create save folder
mkdir tmp;

% Call Panda
AgNet = panda_run(lib_path,exp_file, motif_file, ppi_file, panda_out, save_temp, alpha, save_pairs);

% Load the expected result
ExpAgNet = textread('panda.test.txt');

% Compare the outputs
for i=1:size(AgNet,1)
	for j=1:size(AgNet,2)
		AgNet[i,j]
		ExpAgNet[i,j]
		AgNet[i,j]-ExpAgNet[i,j]
		assert(abs(AgNet[i,j]-ExpAgNet[i,j]) < 1e4*eps(min(abs(AgNet[i,j]),abs(ExpAgNet[i,j]))))
	end
end
