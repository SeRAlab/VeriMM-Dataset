`timescale 1ns/1ps

module mux8to1_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in0;
    reg [3:0] in1;
    reg [3:0] in2;
    reg [3:0] in3;
    reg [3:0] in4;
    reg [3:0] in5;
    reg [3:0] in6;
    reg [3:0] in7;
    reg [2:0] sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux8to1_4bit dut (
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

            in0 = 4'h0; in1 = 4'h1; in2 = 4'h2; in3 = 4'h3;
            in4 = 4'h4; in5 = 4'h5; in6 = 4'h6; in7 = 4'h7;
            sel = 3'b000;
            #10;
            $display("Test %0d: Selecting in0 (Expect 0x0)", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in0 = 4'h0; in1 = 4'h1; in2 = 4'h2; in3 = 4'h3;
            in4 = 4'h4; in5 = 4'h5; in6 = 4'h6; in7 = 4'h7;
            sel = 3'b001;
            #10;
            $display("Test %0d: Selecting in1 (Expect 0x1)", test_num);
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in0 = 4'hA; in1 = 4'hB; in2 = 4'hC; in3 = 4'hD;
            in4 = 4'hE; in5 = 4'hF; in6 = 4'h1; in7 = 4'h2;
            sel = 3'b010;
            #10;
            $display("Test %0d: Selecting in2 (Expect 0xC)", test_num);
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in0 = 4'hA; in1 = 4'hB; in2 = 4'hC; in3 = 4'hD;
            in4 = 4'hE; in5 = 4'hF; in6 = 4'h1; in7 = 4'h2;
            sel = 3'b011;
            #10;
            $display("Test %0d: Selecting in3 (Expect 0xD)", test_num);
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in0 = 4'h5; in1 = 4'h5; in2 = 4'h5; in3 = 4'h5;
            in4 = 4'hA; in5 = 4'h5; in6 = 4'h5; in7 = 4'h5;
            sel = 3'b100;
            #10;
            $display("Test %0d: Selecting in4 (Expect 0xA)", test_num);
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in0 = 4'h0; in1 = 4'h0; in2 = 4'h0; in3 = 4'h0;
            in4 = 4'h0; in5 = 4'h7; in6 = 4'h0; in7 = 4'h0;
            sel = 3'b101;
            #10;
            $display("Test %0d: Selecting in5 (Expect 0x7)", test_num);
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in6 = 4'hE;
            sel = 3'b110;
            #10;
            $display("Test %0d: Selecting in6 (Expect 0xE)", test_num);
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in7 = 4'h9;
            sel = 3'b111;
            #10;
            $display("Test %0d: Selecting in7 (Expect 0x9)", test_num);
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;

            in3 = 4'b1010;
            sel = 3'b011;
            #10;
            $display("Test %0d: Data transparency check on in3 (Expect 0xA)", test_num);
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;

            sel = 3'b000;
            in0 = 4'hF;
            #10;
            in0 = 4'h3;
            #10;
            $display("Test %0d: Dynamic data update check on in0 (Expect 0x3)", test_num);
            #1;

            check_outputs(4'h3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux8to1_4bit Testbench");
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
        input [3:0] expected_out;
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
