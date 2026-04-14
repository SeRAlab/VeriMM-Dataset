`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    reg [3:0] in;
    reg [1:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .in(in),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            VGND = 1'b0; VNB = 1'b0; VPWR = 1'b1; VPB = 1'b1;
            sel = 2'b00;
            in  = 4'b0001;
            $display("Test %0d: Select in[0], in=0001, sel=00", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            VGND = 1'b0; VNB = 1'b0; VPWR = 1'b1; VPB = 1'b1;
            sel = 2'b00;
            in  = 4'b1110;
            $display("Test %0d: Select in[0], in=1110, sel=00", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            VGND = 1'b0; VNB = 1'b0; VPWR = 1'b1; VPB = 1'b1;
            sel = 2'b01;
            in  = 4'b0010;
            $display("Test %0d: Select in[1], in=0010, sel=01", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            VGND = 1'b0; VNB = 1'b0; VPWR = 1'b1; VPB = 1'b1;
            sel = 2'b01;
            in  = 4'b1101;
            $display("Test %0d: Select in[1], in=1101, sel=01", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            VGND = 1'b0; VNB = 1'b0; VPWR = 1'b1; VPB = 1'b1;
            sel = 2'b10;
            in  = 4'b0100;
            $display("Test %0d: Select in[2], in=0100, sel=10", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            VGND = 1'b0; VNB = 1'b0; VPWR = 1'b1; VPB = 1'b1;
            sel = 2'b10;
            in  = 4'b1011;
            $display("Test %0d: Select in[2], in=1011, sel=10", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            VGND = 1'b0; VNB = 1'b0; VPWR = 1'b1; VPB = 1'b1;
            sel = 2'b11;
            in  = 4'b1000;
            $display("Test %0d: Select in[3], in=1000, sel=11", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            VGND = 1'b0; VNB = 1'b0; VPWR = 1'b1; VPB = 1'b1;
            sel = 2'b11;
            in  = 4'b0111;
            $display("Test %0d: Select in[3], in=0111, sel=11", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            VGND = 1'b0; VNB = 1'b0; VPWR = 1'b1; VPB = 1'b1;
            sel = 2'b01;
            in  = 4'b1011;
            $display("Test %0d: Crosstalk check (sel=01, in=1011)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            VGND = 1'b0; VNB = 1'b0; VPWR = 1'b1; VPB = 1'b1;
            sel = 2'b10;
            in  = 4'b1011;
            $display("Test %0d: Crosstalk check (sel=10, in=1011)", test_num);
            #1;

            check_outputs(1'b0);
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
