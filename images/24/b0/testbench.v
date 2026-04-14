`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] received_symbol;
    reg reset;
    wire [1:0] decoded_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    viterbi_decoder dut (
        .clk(clk),
        .received_symbol(received_symbol),
        .reset(reset),
        .decoded_output(decoded_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            received_symbol = 3'b0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Zero input test...");
            test_num = test_num + 1;
            reset_dut();

            received_symbol = 3'b000;
            @(posedge clk);


            #1;



            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Max input test...");
            test_num = test_num + 1;
            reset_dut();

            received_symbol = 3'b111;
            @(posedge clk);


            #1;



            check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Sequential transition test...");
            test_num = test_num + 1;
            reset_dut();

            received_symbol = 3'b100;
            @(posedge clk);
            received_symbol = 3'b010;
            @(posedge clk);


            #1;



            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Alternating pattern test...");
            test_num = test_num + 1;
            reset_dut();

            received_symbol = 3'b101;
            @(posedge clk);
            received_symbol = 3'b010;
            @(posedge clk);
            received_symbol = 3'b101;
            @(posedge clk);

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Mid-operation reset test...");
            test_num = test_num + 1;
            reset_dut();

            received_symbol = 3'b110;
            @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;

            received_symbol = 3'b000;
            @(posedge clk);


            #1;



            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: State 7 transition...");
            test_num = test_num + 1;
            reset_dut();

            received_symbol = 3'b111;
            @(posedge clk);
            received_symbol = 3'b000;
            @(posedge clk);

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Rapid input change test...");
            test_num = test_num + 1;
            reset_dut();

            received_symbol = 3'b001; @(posedge clk);
            received_symbol = 3'b011; @(posedge clk);
            received_symbol = 3'b111; @(posedge clk);
            received_symbol = 3'b110; @(posedge clk);

            #1;


            check_outputs(2'b11);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Boundary state 011 test...");
            test_num = test_num + 1;
            reset_dut();

            received_symbol = 3'b011;
            @(posedge clk);

            #1;


            check_outputs(2'b01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("viterbi_decoder Testbench");
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
        input [1:0] expected_decoded_output;
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
        $dumpvars(0,clk, received_symbol, reset, decoded_output);
    end

endmodule
