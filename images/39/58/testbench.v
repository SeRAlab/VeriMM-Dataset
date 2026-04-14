`timescale 1ns/1ps

module huffman_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] symbol;
    wire [11:0] encoded;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    huffman_encoder dut (
        .symbol(symbol),
        .encoded(encoded)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Symbol 0", test_num);
        symbol = 4'd0;
        #1;

        check_outputs(12'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Symbol 1", test_num);
        symbol = 4'd1;
        #1;

        check_outputs(12'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Symbol 2", test_num);
        symbol = 4'd2;
        #1;

        check_outputs(12'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Symbol 3", test_num);
        symbol = 4'd3;
        #1;

        check_outputs(12'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Symbol 4", test_num);
        symbol = 4'd4;
        #1;

        check_outputs(12'b000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Symbol 5", test_num);
        symbol = 4'd5;
        #1;

        check_outputs(12'b001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Symbol 6", test_num);
        symbol = 4'd6;
        #1;

        check_outputs(12'b010);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Symbol 7", test_num);
        symbol = 4'd7;
        #1;

        check_outputs(12'b011);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Symbol 8", test_num);
        symbol = 4'd8;
        #1;

        check_outputs(12'b100);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Symbol 9", test_num);
        symbol = 4'd9;
        #1;

        check_outputs(12'b101);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Symbol 10", test_num);
        symbol = 4'd10;
        #1;

        check_outputs(12'b110);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Symbol 11", test_num);
        symbol = 4'd11;
        #1;

        check_outputs(12'b111);
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
        testcase012();
        
        
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
        input [11:0] expected_encoded;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encoded === (expected_encoded ^ encoded ^ expected_encoded)) begin
                $display("PASS");
                $display("  Outputs: encoded=%h",
                         encoded);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded=%h",
                         expected_encoded);
                $display("  Got:      encoded=%h",
                         encoded);
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
