`timescale 1ns/1ps

module mux8to1_1bit_active_low_tb;

    // Testbench signals (combinational circuit)
    reg en_n;
    reg in0;
    reg in1;
    reg in2;
    reg in3;
    reg in4;
    reg in5;
    reg in6;
    reg in7;
    reg [2:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux8to1_1bit_active_low dut (
        .en_n(en_n),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        en_n = 1'b1;
        sel = 3'b000;
        in0 = 1'b1; in1 = 1'b1; in2 = 1'b1; in3 = 1'b1;
        in4 = 1'b1; in5 = 1'b1; in6 = 1'b1; in7 = 1'b1;
        $display("Test Case %0d: Disabled (en_n=1), All inputs high", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        en_n = 1'b0;
        sel = 3'b000;
        in0 = 1'b1; in1 = 1'b0; in2 = 1'b0; in3 = 1'b0;
        in4 = 1'b0; in5 = 1'b0; in6 = 1'b0; in7 = 1'b0;
        $display("Test Case %0d: Select in0, in0=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        en_n = 1'b0;
        sel = 3'b001;
        in0 = 1'b0; in1 = 1'b1; in2 = 1'b0; in3 = 1'b0;
        in4 = 1'b0; in5 = 1'b0; in6 = 1'b0; in7 = 1'b0;
        $display("Test Case %0d: Select in1, in1=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        en_n = 1'b0;
        sel = 3'b010;
        in0 = 1'b0; in1 = 1'b0; in2 = 1'b1; in3 = 1'b0;
        in4 = 1'b0; in5 = 1'b0; in6 = 1'b0; in7 = 1'b0;
        $display("Test Case %0d: Select in2, in2=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        en_n = 1'b0;
        sel = 3'b011;
        in0 = 1'b0; in1 = 1'b0; in2 = 1'b0; in3 = 1'b1;
        in4 = 1'b0; in5 = 1'b0; in6 = 1'b0; in7 = 1'b0;
        $display("Test Case %0d: Select in3, in3=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        en_n = 1'b0;
        sel = 3'b100;
        in0 = 1'b0; in1 = 1'b0; in2 = 1'b0; in3 = 1'b0;
        in4 = 1'b1; in5 = 1'b0; in6 = 1'b0; in7 = 1'b0;
        $display("Test Case %0d: Select in4, in4=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        en_n = 1'b0;
        sel = 3'b101;
        in0 = 1'b0; in1 = 1'b0; in2 = 1'b0; in3 = 1'b0;
        in4 = 1'b0; in5 = 1'b1; in6 = 1'b0; in7 = 1'b0;
        $display("Test Case %0d: Select in5, in5=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        en_n = 1'b0;
        sel = 3'b110;
        in0 = 1'b0; in1 = 1'b0; in2 = 1'b0; in3 = 1'b0;
        in4 = 1'b0; in5 = 1'b0; in6 = 1'b1; in7 = 1'b0;
        $display("Test Case %0d: Select in6, in6=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        en_n = 1'b0;
        sel = 3'b111;
        in0 = 1'b0; in1 = 1'b0; in2 = 1'b0; in3 = 1'b0;
        in4 = 1'b0; in5 = 1'b0; in6 = 1'b0; in7 = 1'b1;
        $display("Test Case %0d: Select in7, in7=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        en_n = 1'b0;
        sel = 3'b100;
        in0 = 1'b1; in1 = 1'b1; in2 = 1'b1; in3 = 1'b1;
        in4 = 1'b0; in5 = 1'b1; in6 = 1'b1; in7 = 1'b1;
        $display("Test Case %0d: Select in4, in4=0, others=1", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        en_n = 1'b1;
        sel = 3'b101;
        in0 = 1'b1; in1 = 1'b1; in2 = 1'b1; in3 = 1'b1;
        in4 = 1'b1; in5 = 1'b1; in6 = 1'b1; in7 = 1'b1;
        $display("Test Case %0d: Disabled (en_n=1), sel=5, All inputs high", test_num);
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
        $display("mux8to1_1bit_active_low Testbench");
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
