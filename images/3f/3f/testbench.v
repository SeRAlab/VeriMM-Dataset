`timescale 1ns/1ps

module mux16to1_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in0;
    reg [3:0] in1;
    reg [3:0] in10;
    reg [3:0] in11;
    reg [3:0] in12;
    reg [3:0] in13;
    reg [3:0] in14;
    reg [3:0] in15;
    reg [3:0] in2;
    reg [3:0] in3;
    reg [3:0] in4;
    reg [3:0] in5;
    reg [3:0] in6;
    reg [3:0] in7;
    reg [3:0] in8;
    reg [3:0] in9;
    reg [3:0] sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux16to1 dut (
        .in0(in0),
        .in1(in1),
        .in10(in10),
        .in11(in11),
        .in12(in12),
        .in13(in13),
        .in14(in14),
        .in15(in15),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .in8(in8),
        .in9(in9),
        .sel(sel),
        .out(out)
    );
    task initialize_inputs;

        begin
            in0  = 4'h0; in1  = 4'h1; in2  = 4'h2; in3  = 4'h3;
            in4  = 4'h4; in5  = 4'h5; in6  = 4'h6; in7  = 4'h7;
            in8  = 4'h8; in9  = 4'h9; in10 = 4'hA; in11 = 4'hB;
            in12 = 4'hC; in13 = 4'hD; in14 = 4'hE; in15 = 4'hF;
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Select in0");
            initialize_inputs();
            sel = 4'd0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Select in1");
            initialize_inputs();
            sel = 4'd1;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Select in2");
            initialize_inputs();
            sel = 4'd2;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Select in3");
            initialize_inputs();
            sel = 4'd3;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Select in4");
            initialize_inputs();
            sel = 4'd4;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Select in5");
            initialize_inputs();
            sel = 4'd5;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Select in6");
            initialize_inputs();
            sel = 4'd6;
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Select in7");
            initialize_inputs();
            sel = 4'd7;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Select in8");
            initialize_inputs();
            sel = 4'd8;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Select in9");
            initialize_inputs();
            sel = 4'd9;
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase011;

        begin
            $display("Testcase 011: Select in10");
            initialize_inputs();
            sel = 4'd10;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase012;

        begin
            $display("Testcase 012: Select in11");
            initialize_inputs();
            sel = 4'd11;
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase013;

        begin
            $display("Testcase 013: Select in12");
            initialize_inputs();
            sel = 4'd12;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase014;

        begin
            $display("Testcase 014: Select in13");
            initialize_inputs();
            sel = 4'd13;
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase015;

        begin
            $display("Testcase 015: Select in14");
            initialize_inputs();
            sel = 4'd14;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase016;

        begin
            $display("Testcase 016: Select in15");
            initialize_inputs();
            sel = 4'd15;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase017;

        begin
            $display("Testcase 017: Change input value while selected");
            initialize_inputs();
            sel = 4'd5;
            #5;
            in5 = 4'hA;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase018;

        begin
            $display("Testcase 018: Change select while inputs are constant");
            initialize_inputs();
            sel = 4'd0;
            #5;
            sel = 4'd12;
            #1;

            check_outputs(4'hC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux16to1 Testbench");
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
