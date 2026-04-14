`timescale 1ns/1ps

module data_forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] forward_ctrl;
    reg [7:0] input_a;
    reg [7:0] input_b;
    wire [7:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_unit dut (
        .forward_ctrl(forward_ctrl),
        .input_a(input_a),
        .input_b(input_b),
        .output_data(output_data)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select Input A (forward_ctrl = 2'b01)", test_num);
            input_a = 8'hA5;
            input_b = 8'h5A;
            forward_ctrl = 2'b01;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select Input B (forward_ctrl = 2'b10)", test_num);
            input_a = 8'h12;
            input_b = 8'h34;
            forward_ctrl = 2'b10;
            #1;

            check_outputs(8'h34);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select Default Value (forward_ctrl = 2'b00)", test_num);
            input_a = 8'hFF;
            input_b = 8'hEE;
            forward_ctrl = 2'b00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select Default Value (forward_ctrl = 2'b11)", test_num);
            input_a = 8'h77;
            input_b = 8'h88;
            forward_ctrl = 2'b11;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Boundary Value Max (Input A = 0xFF)", test_num);
            input_a = 8'hFF;
            input_b = 8'h00;
            forward_ctrl = 2'b01;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Boundary Value Min (Input B = 0x00)", test_num);
            input_a = 8'hFF;
            input_b = 8'h00;
            forward_ctrl = 2'b10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Rapid Toggle Selection", test_num);
            input_a = 8'hCC;
            input_b = 8'h33;
            forward_ctrl = 2'b01; #5;
            forward_ctrl = 2'b10; #5;
            forward_ctrl = 2'b01;
            #1;

            check_outputs(8'hCC);
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
