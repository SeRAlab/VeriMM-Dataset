`timescale 1ns/1ps

module decoder_3to8_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] A;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_3to8 dut (
        .A(A),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 3'b000;
        $display("Test %0d: A = %b", test_num, A);
        #1;

        check_outputs(8'b00000001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 3'b001;
        $display("Test %0d: A = %b", test_num, A);
        #1;

        check_outputs(8'b00000010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 3'b010;
        $display("Test %0d: A = %b", test_num, A);
        #1;

        check_outputs(8'b00000100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 3'b011;
        $display("Test %0d: A = %b", test_num, A);
        #1;

        check_outputs(8'b00001000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 3'b100;
        $display("Test %0d: A = %b", test_num, A);
        #1;

        check_outputs(8'b00010000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 3'b101;
        $display("Test %0d: A = %b", test_num, A);
        #1;

        check_outputs(8'b00100000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 3'b110;
        $display("Test %0d: A = %b", test_num, A);
        #1;

        check_outputs(8'b01000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 3'b111;
        $display("Test %0d: A = %b", test_num, A);
        #1;

        check_outputs(8'b10000000);
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
