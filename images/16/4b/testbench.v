`timescale 1ns/1ps

module decoder_3to8_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] A;
    reg EN;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_3to8 dut (
        .A(A),
        .EN(EN),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=0, A=000", test_num);
            EN = 0;
            A = 3'b000;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=0, A=111", test_num);
            EN = 0;
            A = 3'b111;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, A=000", test_num);
            EN = 1;
            A = 3'b000;
            #1;

            check_outputs(8'b1111_1110);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, A=001", test_num);
            EN = 1;
            A = 3'b001;
            #1;

            check_outputs(8'b1111_1101);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, A=010", test_num);
            EN = 1;
            A = 3'b010;
            #1;

            check_outputs(8'b1111_1011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, A=011", test_num);
            EN = 1;
            A = 3'b011;
            #1;

            check_outputs(8'b1111_0111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, A=100", test_num);
            EN = 1;
            A = 3'b100;
            #1;

            check_outputs(8'b1110_1111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, A=101", test_num);
            EN = 1;
            A = 3'b101;
            #1;

            check_outputs(8'b1101_1111);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, A=110", test_num);
            EN = 1;
            A = 3'b110;
            #1;

            check_outputs(8'b1011_1111);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, A=111", test_num);
            EN = 1;
            A = 3'b111;
            #1;

            check_outputs(8'b0111_1111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_3to8 Testbench");
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
        input [7:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
