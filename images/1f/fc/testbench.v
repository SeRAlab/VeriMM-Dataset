`timescale 1ns/1ps

module turbo_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] encoded_input;
    reg rst;
    wire [3:0] decoded_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    turbo_decoder dut (
        .clk(clk),
        .encoded_input(encoded_input),
        .rst(rst),
        .decoded_output(decoded_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            encoded_input = 4'b0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            reset_dut();
            encoded_input = 4'b0000;

            repeat(8) @(posedge clk);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            reset_dut();
            encoded_input = 4'b1111;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating 1010", test_num);
            reset_dut();
            encoded_input = 4'b1010;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating 0101", test_num);
            reset_dut();
            encoded_input = 4'b0101;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Bit High (1000)", test_num);
            reset_dut();
            encoded_input = 4'b1000;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Bit High (0001)", test_num);
            reset_dut();
            encoded_input = 4'b0001;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Middle Bits High (0110)", test_num);
            reset_dut();
            encoded_input = 4'b0110;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern 1011", test_num);
            reset_dut();
            encoded_input = 4'b1011;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(4'b1011);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("turbo_decoder Testbench");
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
        input [3:0] expected_decoded_output;
        begin
            if (expected_decoded_output === (expected_decoded_output ^ decoded_output ^ expected_decoded_output)) begin
                $display("PASS");
                $display("  Outputs: decoded_output=%h",
                         decoded_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_output=%h",
                         expected_decoded_output);
                $display("  Got:      decoded_output=%h",
                         decoded_output);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, encoded_input, rst, decoded_output);
    end

endmodule
