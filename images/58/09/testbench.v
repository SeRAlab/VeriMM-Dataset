`timescale 1ns/1ps

module mux4bit8to1_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] d0;
    reg [3:0] d1;
    reg [3:0] d2;
    reg [3:0] d3;
    reg [3:0] d4;
    reg [3:0] d5;
    reg [3:0] d6;
    reg [3:0] d7;
    reg [2:0] sel;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4bit8to1 dut (
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .d4(d4),
        .d5(d5),
        .d6(d6),
        .d7(d7),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            d0 = 4'hA; d1 = 4'h0; d2 = 4'h0; d3 = 4'h0;
            d4 = 4'h0; d5 = 4'h0; d6 = 4'h0; d7 = 4'h0;
            sel = 3'b000;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            d0 = 4'h0; d1 = 4'hB; d2 = 4'h0; d3 = 4'h0;
            d4 = 4'h0; d5 = 4'h0; d6 = 4'h0; d7 = 4'h0;
            sel = 3'b001;
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            d0 = 4'h0; d1 = 4'h0; d2 = 4'hC; d3 = 4'h0;
            d4 = 4'h0; d5 = 4'h0; d6 = 4'h0; d7 = 4'h0;
            sel = 3'b010;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            d0 = 4'h0; d1 = 4'h0; d2 = 4'h0; d3 = 4'hD;
            d4 = 4'h0; d5 = 4'h0; d6 = 4'h0; d7 = 4'h0;
            sel = 3'b011;
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            d0 = 4'h0; d1 = 4'h0; d2 = 4'h0; d3 = 4'h0;
            d4 = 4'hE; d5 = 4'h0; d6 = 4'h0; d7 = 4'h0;
            sel = 3'b100;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            d0 = 4'h0; d1 = 4'h0; d2 = 4'h0; d3 = 4'h0;
            d4 = 4'h0; d5 = 4'hF; d6 = 4'h0; d7 = 4'h0;
            sel = 3'b101;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            d0 = 4'h0; d1 = 4'h0; d2 = 4'h0; d3 = 4'h0;
            d4 = 4'h0; d5 = 4'h0; d6 = 4'h1; d7 = 4'h0;
            sel = 3'b110;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            d0 = 4'h0; d1 = 4'h0; d2 = 4'h0; d3 = 4'h0;
            d4 = 4'h0; d5 = 4'h0; d6 = 4'h0; d7 = 4'h2;
            sel = 3'b111;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;

            d0 = 4'h0; d1 = 4'h0; d2 = 4'h0; d3 = 4'h0;
            d4 = 4'h5; d5 = 4'h0; d6 = 4'h0; d7 = 4'h0;
            sel = 3'b100;
            #1;
            d4 = 4'h9;
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;

            d0=4'h0; d1=4'h1; d2=4'h2; d3=4'h3; d4=4'h4; d5=4'h5; d6=4'h6; d7=4'h7;
            sel = 3'd7;
            #1;

            check_outputs(4'h7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4bit8to1 Testbench");
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
        input [3:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
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
