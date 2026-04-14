`timescale 1ns/1ps

module mux_16to1_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg d;
    reg e;
    reg f;
    reg g;
    reg h;
    reg i;
    reg j;
    reg k;
    reg l;
    reg m;
    reg n;
    reg o;
    reg p;
    reg [3:0] sel;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_16to1 dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .h(h),
        .i(i),
        .j(j),
        .k(k),
        .l(l),
        .m(m),
        .n(n),
        .o(o),
        .p(p),
        .sel(sel),
        .y(y)
    );
    task set_all_inputs;

        input val;
        begin
            a = val; b = val; c = val; d = val;
            e = val; f = val; g = val; h = val;
            i = val; j = val; k = val; l = val;
            m = val; n = val; o = val; p = val;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            set_all_inputs(0);
            sel = 4'd0; a = 1;
            $display("Test %0d: Select A (sel=0), set A=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            set_all_inputs(0);
            sel = 4'd1; b = 1;
            $display("Test %0d: Select B (sel=1), set B=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            set_all_inputs(0);
            sel = 4'd2; c = 1;
            $display("Test %0d: Select C (sel=2), set C=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            set_all_inputs(0);
            sel = 4'd3; d = 1;
            $display("Test %0d: Select D (sel=3), set D=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            set_all_inputs(0);
            sel = 4'd4; e = 1;
            $display("Test %0d: Select E (sel=4), set E=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            set_all_inputs(0);
            sel = 4'd5; f = 1;
            $display("Test %0d: Select F (sel=5), set F=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            set_all_inputs(0);
            sel = 4'd6; g = 1;
            $display("Test %0d: Select G (sel=6), set G=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            set_all_inputs(0);
            sel = 4'd7; h = 1;
            $display("Test %0d: Select H (sel=7), set H=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            set_all_inputs(0);
            sel = 4'd8; i = 1;
            $display("Test %0d: Select I (sel=8), set I=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            set_all_inputs(0);
            sel = 4'd9; j = 1;
            $display("Test %0d: Select J (sel=9), set J=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            set_all_inputs(0);
            sel = 4'd10; k = 1;
            $display("Test %0d: Select K (sel=10), set K=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            set_all_inputs(0);
            sel = 4'd11; l = 1;
            $display("Test %0d: Select L (sel=11), set L=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            set_all_inputs(0);
            sel = 4'd12; m = 1;
            $display("Test %0d: Select M (sel=12), set M=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            set_all_inputs(0);
            sel = 4'd13; n = 1;
            $display("Test %0d: Select N (sel=13), set N=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            set_all_inputs(0);
            sel = 4'd14; o = 1;
            $display("Test %0d: Select O (sel=14), set O=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            set_all_inputs(0);
            sel = 4'd15; p = 1;
            $display("Test %0d: Select P (sel=15), set P=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase017;

        begin
            test_num = 17;
            set_all_inputs(1);
            sel = 4'd0; a = 0;
            $display("Test %0d: Select A (sel=0), set A=0, others=1", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase018;

        begin
            test_num = 18;
            set_all_inputs(1);
            sel = 4'd15; p = 0;
            $display("Test %0d: Select P (sel=15), set P=0, others=1", test_num);
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
        $display("mux_16to1 Testbench");
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
        testcase014();
        testcase015();
        testcase016();
        testcase017();
        testcase018();
        
        
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
        input expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
                         y);
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
