`timescale 1ns/1ps

module data_forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data1;
    reg [7:0] data2;
    reg select;
    wire [7:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_unit dut (
        .data1(data1),
        .data2(data2),
        .select(select),
        .output_data(output_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select data1 (basic patterns)", test_num);
            data1 = 8'hAA;
            data2 = 8'h55;
            select = 1'b0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select data2 (basic patterns)", test_num);
            data1 = 8'hAA;
            data2 = 8'h55;
            select = 1'b1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All zeros case", test_num);
            data1 = 8'h00;
            data2 = 8'hFF;
            select = 1'b0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All ones case", test_num);
            data1 = 8'h00;
            data2 = 8'hFF;
            select = 1'b1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random selection data1", test_num);
            data1 = 8'h3C;
            data2 = 8'hC3;
            select = 1'b0;
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random selection data2", test_num);
            data1 = 8'h12;
            data2 = 8'h34;
            select = 1'b1;
            #1;

            check_outputs(8'h34);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_forwarding_unit Testbench");
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
        input [7:0] expected_output_data;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
