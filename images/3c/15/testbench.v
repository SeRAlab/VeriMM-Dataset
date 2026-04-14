`timescale 1ns/1ps

module huffman_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] char;
    wire [2:0] code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    huffman_encoder dut (
        .char(char),
        .code(code)
    );
    task testcase001;

    begin
        test_num = 1;
        char = 4'h0;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        char = 4'h1;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        char = 4'h2;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        char = 4'h3;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        char = 4'h4;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        char = 4'h5;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        char = 4'h6;
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        char = 4'h7;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        char = 4'h8;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        char = 4'h9;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        char = 4'hA;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        char = 4'hB;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        char = 4'hC;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        char = 4'hD;
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        char = 4'hE;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        char = 4'hF;
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
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [2:0] expected_code;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_code === (expected_code ^ code ^ expected_code)) begin
                $display("PASS");
                $display("  Outputs: code=%h",
                         code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: code=%h",
                         expected_code);
                $display("  Got:      code=%h",
                         code);
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
