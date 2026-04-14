`timescale 1ns/1ps

module huffman_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] symbol;
    wire [2:0] encoded;

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
        symbol = 4'd0;
        $display("Testcase %0d: Testing Symbol '0'", test_num);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        symbol = 4'd1;
        $display("Testcase %0d: Testing Symbol '1'", test_num);
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        symbol = 4'd2;
        $display("Testcase %0d: Testing Symbol '2'", test_num);
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        symbol = 4'd3;
        $display("Testcase %0d: Testing Symbol '3'", test_num);
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        symbol = 4'd4;
        $display("Testcase %0d: Testing Symbol '4'", test_num);
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        symbol = 4'd5;
        $display("Testcase %0d: Testing Symbol '5'", test_num);
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        symbol = 4'd6;
        $display("Testcase %0d: Testing Symbol '6'", test_num);
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        symbol = 4'd7;
        $display("Testcase %0d: Testing Symbol '7'", test_num);
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
        input [2:0] expected_encoded;
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
