`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] data_in;
    reg reset;
    wire [127:0] hash_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_hash dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .hash_out(hash_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        data_in = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: All Zeros Input", test_num);
        reset_dut();
        data_in = 128'h0;

        repeat(64) @(posedge clk);
        #1;

        #1;


        check_outputs(128'hD41D8CD98F00B204E9800998ECF8427E);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: All Ones Input", test_num);
        reset_dut();
        data_in = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        repeat(64) @(posedge clk);
        #1;
        #1;

        check_outputs(128'h6D29A91D6E77A762510A61580A90F811);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Alternating Bits Pattern (AAA...)", test_num);
        reset_dut();
        data_in = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
        repeat(64) @(posedge clk);
        #1;
        #1;

        check_outputs(128'h4A6178E662F79326079963D6C14202F7);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Alternating Bits Pattern (555...)", test_num);
        reset_dut();
        data_in = 128'h55555555555555555555555555555555;
        repeat(64) @(posedge clk);
        #1;
        #1;

        check_outputs(128'hA16E14ED5A9866F7B1238475A9C127D4);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Incremental Hex Pattern", test_num);
        reset_dut();
        data_in = 128'h000102030405060708090A0B0C0D0E0F;
        repeat(64) @(posedge clk);
        #1;
        #1;

        check_outputs(128'h0D8534C0851E063060C3CC9548E1D8BE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: DEADBEEF Pattern", test_num);
        reset_dut();
        data_in = 128'hDEADBEEFDEADBEEFDEADBEEFDEADBEEF;
        repeat(64) @(posedge clk);
        #1;
        #1;

        check_outputs(128'h7994D183B5E0528652CD5C2691666F6A);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("md5_hash Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [127:0] expected_hash_out;
        begin
            if (expected_hash_out === (expected_hash_out ^ hash_out ^ expected_hash_out)) begin
                $display("PASS");
                $display("  Outputs: hash_out=%h",
                         hash_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash_out=%h",
                         expected_hash_out);
                $display("  Got:      hash_out=%h",
                         hash_out);
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
        $dumpvars(0,clk, data_in, reset, hash_out);
    end

endmodule
