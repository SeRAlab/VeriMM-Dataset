`timescale 1ns/1ps

module alu_barrel_shifter_tb;

    // Testbench signals (combinational circuit)
    reg direction;
    reg [7:0] x;
    reg [7:0] y;
    wire c;
    wire [7:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_barrel_shifter dut (
        .direction(direction),
        .x(x),
        .y(y),
        .c(c),
        .z(z)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Left shift by 0", test_num);
        x = 8'hA5;
        y = 8'd0;
        direction = 1'b1;
        #1;

        check_outputs(1'b0, 8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Right shift by 0", test_num);
        x = 8'hA5;
        y = 8'd0;
        direction = 1'b0;
        #1;

        check_outputs(1'b0, 8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Left shift by 1", test_num);
        x = 8'b10100101;
        y = 8'd1;
        direction = 1'b1;
        #1;

        check_outputs(1'b1, 8'b01001010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Right shift by 1", test_num);
        x = 8'b10100101;
        y = 8'd1;
        direction = 1'b0;
        #1;

        check_outputs(1'b1, 8'b01010010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Left shift by 4", test_num);
        x = 8'h0F;
        y = 8'd4;
        direction = 1'b1;
        #1;

        check_outputs(1'b0, 8'hF0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Right shift by 4", test_num);
        x = 8'hF0;
        y = 8'd4;
        direction = 1'b0;
        #1;

        check_outputs(1'b0, 8'h0F);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Left shift by 7", test_num);
        x = 8'h01;
        y = 8'd7;
        direction = 1'b1;
        #1;

        check_outputs(1'b0, 8'h80);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Right shift by 7", test_num);
        x = 8'h80;
        y = 8'd7;
        direction = 1'b0;
        #1;

        check_outputs(1'b0, 8'h01);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Left shift all bits out (y=8)", test_num);
        x = 8'hFF;
        y = 8'd8;
        direction = 1'b1;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Right shift all bits out (y=8)", test_num);
        x = 8'hFF;
        y = 8'd8;
        direction = 1'b0;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Over-shift Left (y=9)", test_num);
        x = 8'hFF;
        y = 8'd9;
        direction = 1'b1;
        #1;

        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Over-shift Right (y=9)", test_num);
        x = 8'hFF;
        y = 8'd9;
        direction = 1'b0;
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
        $display("alu_barrel_shifter Testbench");
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
        input expected_c;
        input [7:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: c=%b, z=%h",
                         c, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%b, z=%h",
                         expected_c, expected_z);
                $display("  Got:      c=%b, z=%h",
                         c, z);
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
