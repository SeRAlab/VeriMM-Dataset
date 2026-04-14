`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] vd73390;
    wire v4642b6;
    wire [23:0] v8826c0;
    wire [23:0] vd90f46;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .vd73390(vd73390),
        .v4642b6(v4642b6),
        .v8826c0(v8826c0),
        .vd90f46(vd90f46)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        vd73390 = 24'h000000;
        #10;



        #1;




        check_outputs(1'b0, 24'hFF0000, 24'h000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones", test_num);
        vd73390 = 24'hFFFFFF;
        #10;



        #1;




        check_outputs(1'b0, 24'hFFFFFF, 24'h00FF00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern 123456", test_num);
        vd73390 = 24'h123456;
        #10;



        #1;




        check_outputs(1'b0, 24'hFF3456, 24'h003400);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Pattern ABCDEF", test_num);
        vd73390 = 24'hABCDEF;
        #10;



        #1;




        check_outputs(1'b0, 24'hFFCDEF, 24'h00CD00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mask Boundary AND", test_num);
        vd73390 = 24'h00FF00;
        #10;



        #1;




        check_outputs(1'b0, 24'hFFFF00, 24'h00FF00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mask Boundary OR", test_num);
        vd73390 = 24'hFF0000;
        #10;



        #1;




        check_outputs(1'b0, 24'hFF0000, 24'h000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bits AAAAAA", test_num);
        vd73390 = 24'hAAAAAA;
        #10;



        #1;




        check_outputs(1'b0, 24'hFFAAAA, 24'h00AA00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bits 555555", test_num);
        vd73390 = 24'h555555;
        #10;



        #1;




        check_outputs(1'b0, 24'hFF5555, 24'h005500);
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
        input expected_v4642b6;
        input [23:0] expected_v8826c0;
        input [23:0] expected_vd90f46;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_v4642b6 === (expected_v4642b6 ^ v4642b6 ^ expected_v4642b6) &&
                expected_v8826c0 === (expected_v8826c0 ^ v8826c0 ^ expected_v8826c0) &&
                expected_vd90f46 === (expected_vd90f46 ^ vd90f46 ^ expected_vd90f46)) begin
                $display("PASS");
                $display("  Outputs: v4642b6=%b, v8826c0=%h, vd90f46=%h",
                         v4642b6, v8826c0, vd90f46);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: v4642b6=%b, v8826c0=%h, vd90f46=%h",
                         expected_v4642b6, expected_v8826c0, expected_vd90f46);
                $display("  Got:      v4642b6=%b, v8826c0=%h, vd90f46=%h",
                         v4642b6, v8826c0, vd90f46);
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
