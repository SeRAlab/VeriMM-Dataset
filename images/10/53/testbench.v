`timescale 1ns/1ps

module ofdm_transmitter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire [15:0] time_domain_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ofdm_transmitter dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .time_domain_out(time_domain_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h00;
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
            $display("\nTestcase %0d: Zero Input", test_num);
            reset_dut();


            repeat(4) begin
                data_in = 8'h00;
                @(posedge clk);
            end


            repeat(4) @(posedge clk);


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Constant DC Input", test_num);
            reset_dut();


            repeat(4) begin
                data_in = 8'hFF;
                @(posedge clk);
            end


            repeat(4) @(posedge clk);




            #1;





            check_outputs(16'hFF00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Frequency Domain Impulse", test_num);
            reset_dut();


            data_in = 8'h80; @(posedge clk);
            data_in = 8'h00; @(posedge clk);
            data_in = 8'h00; @(posedge clk);
            data_in = 8'h00; @(posedge clk);


            repeat(4) @(posedge clk);


            #1;



            check_outputs(16'h2000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Bit Pattern", test_num);
            reset_dut();


            data_in = 8'hAA; @(posedge clk);
            data_in = 8'h55; @(posedge clk);
            data_in = 8'hAA; @(posedge clk);
            data_in = 8'h55; @(posedge clk);


            repeat(4) @(posedge clk);


            #1;



            check_outputs(16'h7F7F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset During Operation", test_num);
            reset_dut();


            data_in = 8'hFF;
            @(posedge clk);
            @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;


            data_in = 8'h00;
            repeat(4) @(posedge clk);


            #1;



            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ofdm_transmitter Testbench");
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
        input [15:0] expected_time_domain_out;
        begin
            if (expected_time_domain_out === (expected_time_domain_out ^ time_domain_out ^ expected_time_domain_out)) begin
                $display("PASS");
                $display("  Outputs: time_domain_out=%h",
                         time_domain_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: time_domain_out=%h",
                         expected_time_domain_out);
                $display("  Got:      time_domain_out=%h",
                         time_domain_out);
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
        $dumpvars(0,clk, data_in, reset, time_domain_out);
    end

endmodule
