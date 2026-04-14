`timescale 1ns/1ps

module pcie_completer_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    reg [7:0] req_id;
    wire [15:0] data_out;
    wire [7:0] resp_id;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_completer dut (
        .data_in(data_in),
        .req_id(req_id),
        .data_out(data_out),
        .resp_id(resp_id)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimal values", test_num);
            req_id = 8'h00;
            data_in = 16'h0000;
            #1;

            check_outputs(16'h0001, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard operation", test_num);
            req_id = 8'hA5;
            data_in = 16'h1234;
            #1;

            check_outputs(16'h1235, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data overflow (0xFFFF -> 0x0000)", test_num);
            req_id = 8'hFF;
            data_in = 16'hFFFF;
            #1;

            check_outputs(16'h0000, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits", test_num);
            req_id = 8'h55;
            data_in = 16'hAAAA;
            #1;

            check_outputs(16'hAAAB, 8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large request ID and mid-range data", test_num);
            req_id = 8'hFE;
            data_in = 16'h7FFF;
            #1;

            check_outputs(16'h8000, 8'hFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_completer Testbench");
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
        input [15:0] expected_data_out;
        input [7:0] expected_resp_id;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_resp_id === (expected_resp_id ^ resp_id ^ expected_resp_id)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, resp_id=%h",
                         data_out, resp_id);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, resp_id=%h",
                         expected_data_out, expected_resp_id);
                $display("  Got:      data_out=%h, resp_id=%h",
                         data_out, resp_id);
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
