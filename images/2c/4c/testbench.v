`timescale 1ns/1ps

module sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg rst;
    reg start;
    wire [255:0] hash;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256 dut (
        .clk(clk),
        .message(message),
        .rst(rst),
        .start(start),
        .hash(hash),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        start = 0;
        message = 0;
        @(posedge clk);
        #2;
        rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nRunning Testcase %0d: All Zeros (512-bit block)", test_num);
        reset_dut();

        message = 512'h0;
        start = 1;
        @(posedge clk);
        #1 start = 0;


        wait(ready == 1);
        @(posedge clk);


        #1;



        check_outputs(256'hda5698d64aa0c197ef9c93b61074c3b74980317a88151167292261398c2534f5, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nRunning Testcase %0d: 'abc' with padding", test_num);
        reset_dut();

        message = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
        start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(ready == 1);
        @(posedge clk);


        #1;



        check_outputs(256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nRunning Testcase %0d: All Ones (512-bit block)", test_num);
        reset_dut();

        message = {16{32'hFFFFFFFF}};
        start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(ready == 1);
        @(posedge clk);


        #1;



        check_outputs(256'h16035176b92a392b95b86a87796d88e0a16c7f8a3ed3f8ec4e1f72782782b6cc, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nRunning Testcase %0d: Alternating Bits (0xA5...)", test_num);
        reset_dut();

        message = {64{8'hA5}};
        start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(ready == 1);
        @(posedge clk);


        #1;



        check_outputs(256'h331b518693c042299719489270e5616335133664d471550c60f2f3e82746409a, 1);
    end
        endtask

    task testcase005;

    reg [511:0] pattern;
    integer i;
    begin
        test_num = test_num + 1;
        $display("\nRunning Testcase %0d: Incremental Pattern (000102...)", test_num);
        reset_dut();

        for (i = 0; i < 64; i = i + 1) begin
            pattern[i*8 +: 8] = i[7:0];
        end
        message = pattern;

        start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(ready == 1);
        @(posedge clk);


        #1;



        check_outputs(256'h387693d93081e8f278d6596e3828945f35d796726884633857d97771746f3660, 1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sha256 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [255:0] expected_hash;
        input expected_ready;
        begin
            if (expected_hash === (expected_hash ^ hash ^ expected_hash) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: hash=%h, ready=%b",
                         hash, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash=%h, ready=%b",
                         expected_hash, expected_ready);
                $display("  Got:      hash=%h, ready=%b",
                         hash, ready);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, message, rst, start, hash, ready);
    end

endmodule
