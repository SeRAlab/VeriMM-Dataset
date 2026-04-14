`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg enable;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic 4:1 Downsampling - Initial Sample", test_num);
            reset_dut();

            enable = 1;
            data_in = 8'hA5;
            @(posedge clk);
            data_in = 8'h11;
            @(posedge clk);
            data_in = 8'h22;
            @(posedge clk);
            data_in = 8'h33;
            @(posedge clk);


            #1 #1;
 check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rate Change - Second Sample Window", test_num);
            reset_dut();

            enable = 1;
            data_in = 8'hD1;
            @(posedge clk);
            data_in = 8'hD2;
            @(posedge clk);
            data_in = 8'hD3;
            @(posedge clk);
            data_in = 8'hD4;
            @(posedge clk);
            data_in = 8'hBC;
            @(posedge clk);
            data_in = 8'hE2;
            @(posedge clk);


            #1 #1;
 check_outputs(8'hBC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Signal Gating", test_num);
            reset_dut();


            enable = 1;
            data_in = 8'h10;
            @(posedge clk);
            enable = 0;
            data_in = 8'hFF;
            repeat(10) @(posedge clk);


            #1 #1;
 check_outputs(8'h10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Continuous Data Stream", test_num);
            reset_dut();

            enable = 1;

            data_in = 8'h01; @(posedge clk);
            data_in = 8'h02; @(posedge clk);
            data_in = 8'h03; @(posedge clk);
            data_in = 8'h04; @(posedge clk);

            data_in = 8'h05; @(posedge clk);
            data_in = 8'h06; @(posedge clk);
            data_in = 8'h07; @(posedge clk);
            data_in = 8'h08; @(posedge clk);

            data_in = 8'h09; @(posedge clk);
            data_in = 8'h0A; @(posedge clk);
            data_in = 8'h0B; @(posedge clk);
            data_in = 8'h0C; @(posedge clk);


            #1 #1;
 check_outputs(8'h09);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Data Handling", test_num);
            reset_dut();

            enable = 1;
            data_in = 8'hFF;
            @(posedge clk);
            repeat(3) @(posedge clk);

            data_in = 8'h00;
            @(posedge clk);
            repeat(3) @(posedge clk);

            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sample_rate_converter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, enable, data_out);
    end

endmodule
