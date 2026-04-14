`timescale 1ns/1ps

module aes_sbox_lookup_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] input_data;
    wire [3:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_sbox_lookup dut (
        .clk(clk),
        .input_data(input_data),
        .output_data(output_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            input_data = 4'h0;

            repeat (2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Input 0x0");
            reset_dut();
            input_data = 4'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Input 0x5");
            reset_dut();
            input_data = 4'h5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Input 0xA");
            reset_dut();
            input_data = 4'hA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Input 0xF");
            reset_dut();
            input_data = 4'hF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Sequential logic check");
            reset_dut();


            input_data = 4'h1;
            @(posedge clk);
            #1;


            input_data = 4'hE;
            #1;
            #1;

            check_outputs(4'h5);


            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Boundary check (0x7, 0x8)");
            reset_dut();

            input_data = 4'h7;
            @(posedge clk);
            #2;
            if (output_data !== 4'hD) begin
                #1;

                check_outputs(4'hD);
            end else begin
                input_data = 4'h8;
                @(posedge clk);
                #2;
                #1;

                check_outputs(4'h3);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_sbox_lookup Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [3:0] expected_output_data;
        begin
            if (expected_output_data === (expected_output_data ^ output_data ^ expected_output_data)) begin
                $display("PASS");
                $display("  Outputs: output_data=%h",
                         output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_data=%h",
                         expected_output_data);
                $display("  Got:      output_data=%h",
                         output_data);
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
        $dumpvars(0,clk, input_data, output_data);
    end

endmodule
