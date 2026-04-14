`timescale 1ns/1ps

module chacha20_round_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] key;
    reg [31:0] nonce;
    wire [31:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_round dut (
        .clk(clk),
        .key(key),
        .nonce(nonce),
        .output_data(output_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        key <= 32'h0;
        nonce <= 32'h0;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running testcase%03d: All Zeros", test_num);
        reset_dut();
        key <= 32'h00000000;
        nonce <= 32'h00000000;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running testcase%03d: Key only", test_num);
        reset_dut();
        key <= 32'h12345678;
        nonce <= 32'h00000000;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(32'hCC999897);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running testcase%03d: Nonce only", test_num);
        reset_dut();
        key <= 32'h00000000;
        nonce <= 32'h00000001;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(32'hDEADBEEE);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running testcase%03d: Overflow Addition", test_num);
        reset_dut();
        key <= 32'hFFFFFFFF;
        nonce <= 32'h00000001;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running testcase%03d: Patterned Bits", test_num);
        reset_dut();
        key <= 32'hAAAAAAAA;
        nonce <= 32'h55555555;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(32'h21524110);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_round Testbench");
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
        input [31:0] expected_output_data;
        begin
            if (expected_output_data === (expected_output_data ^ output_data ^ expected_output_data)) begin
                $display("PASS");
                $display("  Outputs: output_data=%h",
                         output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_data=%h",
                         expected_output_data);
                $display("  Got:      output_data=%h",
                         output_data);
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
        $dumpvars(0,clk, key, nonce, output_data);
    end

endmodule
