`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ALUSrc;
    reg [7:0] ReadData2;
    reg [7:0] s_extend;
    wire [7:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUSrc(ALUSrc),
        .ReadData2(ReadData2),
        .s_extend(s_extend),
        .res(res)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Select ReadData2 (ALUSrc = 0)", test_num);
        ALUSrc = 1'b0;
        ReadData2 = 8'hA5;
        s_extend = 8'h5A;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select s_extend (ALUSrc = 1)", test_num);
        ALUSrc = 1'b1;
        ReadData2 = 8'hA5;
        s_extend = 8'h5A;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Select ReadData2 with Zero/All-Ones (ALUSrc = 0)", test_num);
        ALUSrc = 1'b0;
        ReadData2 = 8'h00;
        s_extend = 8'hFF;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Select s_extend with Zero/All-Ones (ALUSrc = 1)", test_num);
        ALUSrc = 1'b1;
        ReadData2 = 8'h00;
        s_extend = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Select ReadData2 with arbitrary value (ALUSrc = 0)", test_num);
        ALUSrc = 1'b0;
        ReadData2 = 8'h12;
        s_extend = 8'h34;
        #1;

        check_outputs(8'h12);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Select s_extend with arbitrary value (ALUSrc = 1)", test_num);
        ALUSrc = 1'b1;
        ReadData2 = 8'h12;
        s_extend = 8'h34;
        #1;

        check_outputs(8'h34);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Select ReadData2 when both inputs are same (ALUSrc = 0)", test_num);
        ALUSrc = 1'b0;
        ReadData2 = 8'hEE;
        s_extend = 8'hEE;
        #1;

        check_outputs(8'hEE);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Select s_extend when both inputs are same (ALUSrc = 1)", test_num);
        ALUSrc = 1'b1;
        ReadData2 = 8'hEE;
        s_extend = 8'hEE;
        #1;

        check_outputs(8'hEE);
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
        input [7:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%h",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h",
                         expected_res);
                $display("  Got:      res=%h",
                         res);
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
