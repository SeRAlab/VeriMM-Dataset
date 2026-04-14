`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] key;
    reg [7:0] mem_addr;
    reg [7:0] mem_data;
    wire [7:0] enc_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .key(key),
        .mem_addr(mem_addr),
        .mem_data(mem_data),
        .enc_data(enc_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity (Key = 0)", test_num);
            mem_addr = 8'h0A;
            mem_data = 8'hAA;
            key      = 8'h00;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit Inversion (Key = FF)", test_num);
            mem_addr = 8'h10;
            mem_data = 8'h55;
            key      = 8'hFF;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Same Data and Key (Result = 0)", test_num);
            mem_addr = 8'h20;
            mem_data = 8'hA5;
            key      = 8'hA5;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Specific Encryption Value", test_num);
            mem_addr = 8'h30;
            mem_data = 8'h12;
            key      = 8'h34;
            #1;

            check_outputs(8'h26);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Decryption (Double XOR)", test_num);

            mem_addr = 8'h30;
            mem_data = 8'h26;
            key      = 8'h34;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Boundary", test_num);
            mem_addr = 8'h00;
            mem_data = 8'h00;
            key      = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Boundary", test_num);
            mem_addr = 8'hFF;
            mem_data = 8'hFF;
            key      = 8'hFF;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Address Change Check", test_num);
            mem_addr = 8'hF0;
            mem_data = 8'hCC;
            key      = 8'h33;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_enc_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_enc_data === (expected_enc_data ^ enc_data ^ expected_enc_data)) begin
                $display("PASS");
                $display("  Outputs: enc_data=%h",
                         enc_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: enc_data=%h",
                         expected_enc_data);
                $display("  Got:      enc_data=%h",
                         enc_data);
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

endmodule
