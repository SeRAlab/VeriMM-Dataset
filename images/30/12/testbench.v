`timescale 1ns/1ps

module turbo_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] encoded_bits;
    reg reset;
    wire [3:0] decoded_bits;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    turbo_decoder dut (
        .clk(clk),
        .encoded_bits(encoded_bits),
        .reset(reset),
        .decoded_bits(decoded_bits)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            encoded_bits = 4'b0000;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: All Zeros", test_num);
            reset_dut();
            encoded_bits = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: All Ones", test_num);
            reset_dut();
            encoded_bits = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Majority High (0111)", test_num);
            reset_dut();
            encoded_bits = 4'b0111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Majority High (1101)", test_num);
            reset_dut();
            encoded_bits = 4'b1101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Majority Low (1000)", test_num);
            reset_dut();
            encoded_bits = 4'b1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Majority Low (0010)", test_num);
            reset_dut();
            encoded_bits = 4'b0010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Tie Case (1100)", test_num);
            reset_dut();
            encoded_bits = 4'b1100;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Output during Reset", test_num);
            reset = 1;
            encoded_bits = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
            reset = 0;
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
        input [3:0] expected_decoded_bits;
        begin
            if (expected_decoded_bits === (expected_decoded_bits ^ decoded_bits ^ expected_decoded_bits)) begin
                $display("PASS");
                $display("  Outputs: decoded_bits=%h",
                         decoded_bits);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_bits=%h",
                         expected_decoded_bits);
                $display("  Got:      decoded_bits=%h",
                         decoded_bits);
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
        $dumpvars(0,clk, encoded_bits, reset, decoded_bits);
    end

endmodule
