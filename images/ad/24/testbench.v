`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] dataIn_data;
    reg dataIn_last;
    reg dataIn_valid;
    reg dataOut_0_ready;
    reg dataOut_1_ready;
    wire dataIn_ready;
    wire [63:0] dataOut_0_data;
    wire dataOut_0_last;
    wire dataOut_0_valid;
    wire [63:0] dataOut_1_data;
    wire dataOut_1_last;
    wire dataOut_1_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dataIn_data(dataIn_data),
        .dataIn_last(dataIn_last),
        .dataIn_valid(dataIn_valid),
        .dataOut_0_ready(dataOut_0_ready),
        .dataOut_1_ready(dataOut_1_ready),
        .dataIn_ready(dataIn_ready),
        .dataOut_0_data(dataOut_0_data),
        .dataOut_0_last(dataOut_0_last),
        .dataOut_0_valid(dataOut_0_valid),
        .dataOut_1_data(dataOut_1_data),
        .dataOut_1_last(dataOut_1_last),
        .dataOut_1_valid(dataOut_1_valid)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All Ready, Valid Data", test_num);
            dataIn_data = 64'hABCDEF0123456789;
            dataIn_last = 1'b0;
            dataIn_valid = 1'b1;
            dataOut_0_ready = 1'b1;
            dataOut_1_ready = 1'b1;





            #1;






            check_outputs(1'b1, 64'hABCDEF0123456789, 1'b0, 1'b1, 64'hABCDEF0123456789, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Backpressure on Stream 1", test_num);
            dataIn_data = 64'h1111222233334444;
            dataIn_last = 1'b1;
            dataIn_valid = 1'b1;
            dataOut_0_ready = 1'b1;
            dataOut_1_ready = 1'b0;







            #1;








            check_outputs(1'b0, 64'h1111222233334444, 1'b1, 1'b0, 64'h1111222233334444, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Backpressure on Stream 0", test_num);
            dataIn_data = 64'h5555666677778888;
            dataIn_last = 1'b0;
            dataIn_valid = 1'b1;
            dataOut_0_ready = 1'b0;
            dataOut_1_ready = 1'b1;





            #1;






            check_outputs(1'b0, 64'h5555666677778888, 1'b0, 1'b1, 64'h5555666677778888, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Full Backpressure", test_num);
            dataIn_data = 64'h9999AAAA9999AAAA;
            dataIn_last = 1'b1;
            dataIn_valid = 1'b1;
            dataOut_0_ready = 1'b0;
            dataOut_1_ready = 1'b0;

            #1;


            check_outputs(1'b0, 64'h9999AAAA9999AAAA, 1'b1, 1'b0, 64'h9999AAAA9999AAAA, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Idle State (No Input Valid)", test_num);
            dataIn_data = 64'h0;
            dataIn_last = 1'b0;
            dataIn_valid = 1'b0;
            dataOut_0_ready = 1'b1;
            dataOut_1_ready = 1'b1;

            #1;


            check_outputs(1'b1, 64'h0, 1'b0, 1'b0, 64'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Data Integrity Check", test_num);
            dataIn_data = 64'hFEDCBA9876543210;
            dataIn_last = 1'b1;
            dataIn_valid = 1'b1;
            dataOut_0_ready = 1'b1;
            dataOut_1_ready = 1'b1;

            #1;


            check_outputs(1'b1, 64'hFEDCBA9876543210, 1'b1, 1'b1, 64'hFEDCBA9876543210, 1'b1, 1'b1);
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
        input expected_dataIn_ready;
        input [63:0] expected_dataOut_0_data;
        input expected_dataOut_0_last;
        input expected_dataOut_0_valid;
        input [63:0] expected_dataOut_1_data;
        input expected_dataOut_1_last;
        input expected_dataOut_1_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dataIn_ready === (expected_dataIn_ready ^ dataIn_ready ^ expected_dataIn_ready) &&
                expected_dataOut_0_data === (expected_dataOut_0_data ^ dataOut_0_data ^ expected_dataOut_0_data) &&
                expected_dataOut_0_last === (expected_dataOut_0_last ^ dataOut_0_last ^ expected_dataOut_0_last) &&
                expected_dataOut_0_valid === (expected_dataOut_0_valid ^ dataOut_0_valid ^ expected_dataOut_0_valid) &&
                expected_dataOut_1_data === (expected_dataOut_1_data ^ dataOut_1_data ^ expected_dataOut_1_data) &&
                expected_dataOut_1_last === (expected_dataOut_1_last ^ dataOut_1_last ^ expected_dataOut_1_last) &&
                expected_dataOut_1_valid === (expected_dataOut_1_valid ^ dataOut_1_valid ^ expected_dataOut_1_valid)) begin
                $display("PASS");
                $display("  Outputs: dataIn_ready=%b, dataOut_0_data=%h, dataOut_0_last=%b, dataOut_0_valid=%b, dataOut_1_data=%h, dataOut_1_last=%b, dataOut_1_valid=%b",
                         dataIn_ready, dataOut_0_data, dataOut_0_last, dataOut_0_valid, dataOut_1_data, dataOut_1_last, dataOut_1_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataIn_ready=%b, dataOut_0_data=%h, dataOut_0_last=%b, dataOut_0_valid=%b, dataOut_1_data=%h, dataOut_1_last=%b, dataOut_1_valid=%b",
                         expected_dataIn_ready, expected_dataOut_0_data, expected_dataOut_0_last, expected_dataOut_0_valid, expected_dataOut_1_data, expected_dataOut_1_last, expected_dataOut_1_valid);
                $display("  Got:      dataIn_ready=%b, dataOut_0_data=%h, dataOut_0_last=%b, dataOut_0_valid=%b, dataOut_1_data=%h, dataOut_1_last=%b, dataOut_1_valid=%b",
                         dataIn_ready, dataOut_0_data, dataOut_0_last, dataOut_0_valid, dataOut_1_data, dataOut_1_last, dataOut_1_valid);
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
