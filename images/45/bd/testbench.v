`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] visor_x;
    reg [1:0] visor_y;
    wire is_number;
    wire [7:0] valor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .visor_x(visor_x),
        .visor_y(visor_y),
        .is_number(is_number),
        .valor(valor)
    );
    task testcase001;

    begin
        visor_x = 3'd0; visor_y = 2'd0;
        #1;

        check_outputs(1'b1, 8'h31);
    end
        endtask

    task testcase002;

    begin
        visor_x = 3'd1; visor_y = 2'd0;
        #1;

        check_outputs(1'b1, 8'h32);
    end
        endtask

    task testcase003;

    begin
        visor_x = 3'd2; visor_y = 2'd0;
        #1;

        check_outputs(1'b1, 8'h33);
    end
        endtask

    task testcase004;

    begin
        visor_x = 3'd0; visor_y = 2'd1;
        #1;

        check_outputs(1'b1, 8'h34);
    end
        endtask

    task testcase005;

    begin
        visor_x = 3'd1; visor_y = 2'd1;
        #1;

        check_outputs(1'b1, 8'h35);
    end
        endtask

    task testcase006;

    begin
        visor_x = 3'd2; visor_y = 2'd1;
        #1;

        check_outputs(1'b1, 8'h36);
    end
        endtask

    task testcase007;

    begin
        visor_x = 3'd0; visor_y = 2'd2;
        #1;

        check_outputs(1'b1, 8'h37);
    end
        endtask

    task testcase008;

    begin
        visor_x = 3'd1; visor_y = 2'd2;
        #1;

        check_outputs(1'b1, 8'h38);
    end
        endtask

    task testcase009;

    begin
        visor_x = 3'd2; visor_y = 2'd2;
        #1;

        check_outputs(1'b1, 8'h39);
    end
        endtask

    task testcase010;

    begin
        visor_x = 3'd1; visor_y = 2'd3;
        #1;

        check_outputs(1'b1, 8'h30);
    end
        endtask

    task testcase011;

    begin
        visor_x = 3'd0; visor_y = 2'd3;
        #1;

        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase012;

    begin
        visor_x = 3'd2; visor_y = 2'd3;
        #1;

        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase013;

    begin
        visor_x = 3'd4; visor_y = 2'd1;
        #1;

        check_outputs(1'b0, 8'h00);
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        
        
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
        input expected_is_number;
        input [7:0] expected_valor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_is_number === (expected_is_number ^ is_number ^ expected_is_number) &&
                expected_valor === (expected_valor ^ valor ^ expected_valor)) begin
                $display("PASS");
                $display("  Outputs: is_number=%b, valor=%h",
                         is_number, valor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_number=%b, valor=%h",
                         expected_is_number, expected_valor);
                $display("  Got:      is_number=%b, valor=%h",
                         is_number, valor);
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
