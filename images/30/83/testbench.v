`timescale 1ns/1ps

module pcie_request_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] request_type;
    wire [1:0] command;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_request_decoder dut (
        .request_type(request_type),
        .command(command)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Request Type 0000", test_num);
            request_type = 4'b0000;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Request Type 0001", test_num);
            request_type = 4'b0001;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Request Type 0010", test_num);
            request_type = 4'b0010;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Request Type 0011", test_num);
            request_type = 4'b0011;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Request Type 0100 (Default Case)", test_num);
            request_type = 4'b0100;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Request Type 1111 (Default Case)", test_num);
            request_type = 4'b1111;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Request Type 1010 (Default Case)", test_num);
            request_type = 4'b1010;
            #1;

            check_outputs(2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_request_decoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [1:0] expected_command;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_command === (expected_command ^ command ^ expected_command)) begin
                $display("PASS");
                $display("  Outputs: command=%h",
                         command);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: command=%h",
                         expected_command);
                $display("  Got:      command=%h",
                         command);
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
