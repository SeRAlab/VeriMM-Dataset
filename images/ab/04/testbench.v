`timescale 1ns/1ps

module mux8to1_4bit_active_low_tb;

    // Testbench signals (combinational circuit)
    reg en_n;
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
    mux8to1_4bit_active_low dut (
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
            $display("Testcase %0d: Enable high (disabled), output should be 0", test_num);
            en_n = 1'b1;
            sel = 3'b000;
            in0 = 4'h1; in1 = 4'h2; in2 = 4'h3; in3 = 4'h4;
            in4 = 4'h5; in5 = 4'h6; in6 = 4'h7; in7 = 4'h8;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select input 0", test_num);
            en_n = 1'b0;
            sel = 3'b000;
            in0 = 4'hA;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select input 1", test_num);
            en_n = 1'b0;
            sel = 3'b001;
            in1 = 4'hB;
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select input 2", test_num);
            en_n = 1'b0;
            sel = 3'b010;
            in2 = 4'hC;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select input 3", test_num);
            en_n = 1'b0;
            sel = 3'b011;
            in3 = 4'hD;
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select input 4", test_num);
            en_n = 1'b0;
            sel = 3'b100;
            in4 = 4'hE;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Select input 5", test_num);
            en_n = 1'b0;
            sel = 3'b101;
            in5 = 4'hF;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Select input 6", test_num);
            en_n = 1'b0;
            sel = 3'b110;
            in6 = 4'h1;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Select input 7", test_num);
            en_n = 1'b0;
            sel = 3'b111;
            in7 = 4'h9;
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Verify data change on selected input", test_num);
            en_n = 1'b0;
            sel = 3'b011;
            in3 = 4'h7;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Testcase %0d: Disable with active inputs", test_num);
            en_n = 1'b1;
            sel = 3'b011;
            in3 = 4'hF;
            #1;

            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux8to1_4bit_active_low Testbench");
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
