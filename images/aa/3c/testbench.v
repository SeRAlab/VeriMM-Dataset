`timescale 1ns/1ps

module mux8to1_8bit_active_low_tb;

    // Testbench signals (combinational circuit)
    reg en_n;
    reg [7:0] in0;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;
    reg [7:0] in4;
    reg [7:0] in5;
    reg [7:0] in6;
    reg [7:0] in7;
    reg [2:0] sel;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux8to1_8bit_active_low dut (
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
            $display("Test Case %0d: Select in0 (en_n=0, sel=000)", test_num);
            en_n = 0; sel = 3'b000;
            in0 = 8'hAA; in1 = 8'h00; in2 = 8'h00; in3 = 8'h00;
            in4 = 8'h00; in5 = 8'h00; in6 = 8'h00; in7 = 8'h00;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select in1 (en_n=0, sel=001)", test_num);
            en_n = 0; sel = 3'b001;
            in0 = 8'h00; in1 = 8'hBB; in2 = 8'h00; in3 = 8'h00;
            in4 = 8'h00; in5 = 8'h00; in6 = 8'h00; in7 = 8'h00;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select in2 (en_n=0, sel=010)", test_num);
            en_n = 0; sel = 3'b010;
            in0 = 8'h00; in1 = 8'h00; in2 = 8'hCC; in3 = 8'h00;
            in4 = 8'h00; in5 = 8'h00; in6 = 8'h00; in7 = 8'h00;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select in3 (en_n=0, sel=011)", test_num);
            en_n = 0; sel = 3'b011;
            in0 = 8'h00; in1 = 8'h00; in2 = 8'h00; in3 = 8'hDD;
            in4 = 8'h00; in5 = 8'h00; in6 = 8'h00; in7 = 8'h00;
            #1;

            check_outputs(8'hDD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Select in4 (en_n=0, sel=100)", test_num);
            en_n = 0; sel = 3'b100;
            in0 = 8'h00; in1 = 8'h00; in2 = 8'h00; in3 = 8'h00;
            in4 = 8'hEE; in5 = 8'h00; in6 = 8'h00; in7 = 8'h00;
            #1;

            check_outputs(8'hEE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Select in5 (en_n=0, sel=101)", test_num);
            en_n = 0; sel = 3'b101;
            in0 = 8'h00; in1 = 8'h00; in2 = 8'h00; in3 = 8'h00;
            in4 = 8'h00; in5 = 8'hFF; in6 = 8'h00; in7 = 8'h00;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Select in6 (en_n=0, sel=110)", test_num);
            en_n = 0; sel = 3'b110;
            in0 = 8'h00; in1 = 8'h00; in2 = 8'h00; in3 = 8'h00;
            in4 = 8'h00; in5 = 8'h00; in6 = 8'h11; in7 = 8'h00;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Select in7 (en_n=0, sel=111)", test_num);
            en_n = 0; sel = 3'b111;
            in0 = 8'h00; in1 = 8'h00; in2 = 8'h00; in3 = 8'h00;
            in4 = 8'h00; in5 = 8'h00; in6 = 8'h00; in7 = 8'h22;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Disabled (en_n=1, sel=000)", test_num);
            en_n = 1; sel = 3'b000;
            in0 = 8'hFF; in1 = 8'hFF; in2 = 8'hFF; in3 = 8'hFF;
            in4 = 8'hFF; in5 = 8'hFF; in6 = 8'hFF; in7 = 8'hFF;


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Disabled (en_n=1, sel=111)", test_num);
            en_n = 1; sel = 3'b111;
            in0 = 8'h55; in1 = 8'h55; in2 = 8'h55; in3 = 8'h55;
            in4 = 8'h55; in5 = 8'h55; in6 = 8'h55; in7 = 8'h55;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux8to1_8bit_active_low Testbench");
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
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
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
