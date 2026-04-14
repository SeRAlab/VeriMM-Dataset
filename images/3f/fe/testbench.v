`timescale 1ns/1ps

module huffman_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] symbol;
    wire [2:0] huffman_code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    huffman_encoder dut (
        .symbol(symbol),
        .huffman_code(huffman_code)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Symbol 0", test_num);
        symbol = 4'd0;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Symbol 1", test_num);
        symbol = 4'd1;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Symbol 2", test_num);
        symbol = 4'd2;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Symbol 3", test_num);
        symbol = 4'd3;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Symbol 4", test_num);
        symbol = 4'd4;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Symbol 5", test_num);
        symbol = 4'd5;
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Symbol 6", test_num);
        symbol = 4'd6;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Symbol 7", test_num);
        symbol = 4'd7;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Symbol 8 (Invalid)", test_num);
        symbol = 4'd8;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Symbol 11 (Invalid)", test_num);
        symbol = 4'd11;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Symbol 15 (Invalid)", test_num);
        symbol = 4'd15;
        #1;

        check_outputs(3'b111);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("huffman_encoder Testbench");
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
        input [2:0] expected_huffman_code;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_huffman_code === (expected_huffman_code ^ huffman_code ^ expected_huffman_code)) begin
                $display("PASS");
                $display("  Outputs: huffman_code=%h",
                         huffman_code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: huffman_code=%h",
                         expected_huffman_code);
                $display("  Got:      huffman_code=%h",
                         huffman_code);
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
