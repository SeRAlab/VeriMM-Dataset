`timescale 1ns/1ps

module fft_64point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data_in;
    reg reset;
    wire [63:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_64point dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 64'b0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            for (i = 0; i < 64; i = i + 1) begin
                data_in = 64'h00000000_00000000;
                @(posedge clk);
            end

            data_in = 64'h0;


            wait(done == 1'b1);


            #1;



            check_outputs(64'h00000000_00000000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            data_in = 64'h00000001_00000000;
            @(posedge clk);


            for (i = 1; i < 64; i = i + 1) begin
                data_in = 64'h00000000_00000000;
                @(posedge clk);
            end

            data_in = 64'h0;


            wait(done == 1'b1);




            #1;





            check_outputs(64'h00000001_00000000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            for (i = 0; i < 64; i = i + 1) begin
                data_in = 64'h00000001_00000000;
                @(posedge clk);
            end

            data_in = 64'h0;


            wait(done == 1'b1);






            #1;







            check_outputs(64'h00000000_00000000, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fft_64point Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        input [63:0] expected_data_out;
        input expected_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b",
                         data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b",
                         expected_data_out, expected_done);
                $display("  Got:      data_out=%h, done=%b",
                         data_out, done);
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
        $dumpvars(0,clk, data_in, reset, data_out, done);
    end

endmodule
