`timescale 1ns/1ps

module des_encryption_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data;
    reg [63:0] key;
    reg rst;
    wire [63:0] encrypted_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    des_encryption dut (
        .clk(clk),
        .data(data),
        .key(key),
        .rst(rst),
        .encrypted_output(encrypted_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data = 64'h0;
            key = 64'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            reset_dut();
            data = 64'h0000000000000000;
            key  = 64'h0000000000000000;


            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Data, All Ones Key", test_num);
            reset_dut();
            data = 64'h0000000000000000;
            key  = 64'hFFFFFFFFFFFFFFFF;

            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones Data, Zero Key", test_num);
            reset_dut();
            data = 64'hFFFFFFFFFFFFFFFF;
            key  = 64'h0000000000000000;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits", test_num);
            reset_dut();
            data = 64'hAAAAAAAAAAAAAAAA;
            key  = 64'h5555555555555555;

            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Specific Mixed Pattern", test_num);
            reset_dut();
            data = 64'h123456789ABCDEF0;
            key  = 64'hFEDCBA9876543210;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("des_encryption Testbench");
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
        input [63:0] expected_encrypted_output;
        begin
            if (expected_encrypted_output === (expected_encrypted_output ^ encrypted_output ^ expected_encrypted_output)) begin
                $display("PASS");
                $display("  Outputs: encrypted_output=%h",
                         encrypted_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encrypted_output=%h",
                         expected_encrypted_output);
                $display("  Got:      encrypted_output=%h",
                         encrypted_output);
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
        $dumpvars(0,clk, data, key, rst, encrypted_output);
    end

endmodule
