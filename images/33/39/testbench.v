`timescale 1ns/1ps

module sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg rst;
    reg start;
    wire [255:0] hash;
    wire valid;

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
        .valid(valid)
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
        repeat (2) @(posedge clk);
        #1 rst = 0;
        repeat (1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %0d: All Zeros Block", test_num);
        reset_dut();
        message = 512'h0;
        start = 1;
        @(posedge clk);
        #1 start = 0;


        wait(valid == 1);
        @(posedge clk);
        #1;

        check_outputs(256'hf5a5fd42d16a20302798ef6ed309979b43003d2320d9f0e8ea9831a92759fb4b, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %0d: All Ones Block", test_num);
        reset_dut();
        message = {16{32'hffffffff}};
        start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(valid == 1);
        @(posedge clk);
        #1;

        check_outputs(256'h2306ad24879482c366f39644f8865233c16295ca9f5cfcd22e519c968e7c3733, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %0d: 'abc' Padded Block", test_num);
        reset_dut();
        message = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
        start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(valid == 1);
        @(posedge clk);
        #1;

        check_outputs(256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %0d: Incremental Pattern", test_num);
        reset_dut();
        message = 512'h000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F202122232425262728292A2B2C2D2E2F303132333435363738393A3B3C3D3E3F;
        start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(valid == 1);
        @(posedge clk);
        #1;

        check_outputs(256'h5c20c4c47f7d1f56a5c1388656f505f13b19f0412808c109724edeb7741893c0, 1'b1);
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
        input expected_valid;
        begin
            if (expected_hash === (expected_hash ^ hash ^ expected_hash) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: hash=%h, valid=%b",
                         hash, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash=%h, valid=%b",
                         expected_hash, expected_valid);
                $display("  Got:      hash=%h, valid=%b",
                         hash, valid);
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
        $dumpvars(0,clk, message, rst, start, hash, valid);
    end

endmodule
