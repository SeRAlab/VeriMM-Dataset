`timescale 1ns/1ps

module sd_card_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] cmd;
    reg [7:0] data_in;
    reg reset;
    wire [7:0] data_out;
    wire error;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_controller dut (
        .clk(clk),
        .cmd(cmd),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out),
        .error(error),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            cmd = 2'b00;
            data_in = 8'h00;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Verify Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Perform Write Operation", test_num);
            reset_dut();

            @(negedge clk);
            cmd = 2'b10;
            data_in = 8'hA5;

            @(posedge clk);
            cmd = 2'b00;


            while (ready === 0) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Perform Read Operation", test_num);
            reset_dut();

            @(negedge clk);
            cmd = 2'b01;

            @(posedge clk);
            cmd = 2'b00;


            while (ready === 0) @(posedge clk);
            #1;



            #1;




            check_outputs(data_out, 0, 1);
        end
        endtask

    task testcase004;

        reg [7:0] captured_data;
        begin
            test_num = 4;
            $display("Testcase %03d: Write then Read Sequence", test_num);
            reset_dut();


            @(negedge clk);
            cmd = 2'b10;
            data_in = 8'h5A;
            @(posedge clk);
            cmd = 2'b00;
            while (ready === 0) @(posedge clk);


            @(negedge clk);
            cmd = 2'b01;
            @(posedge clk);
            cmd = 2'b00;
            while (ready === 0) @(posedge clk);
            #1;


            #1;



            check_outputs(8'h5A, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Invalid Command Error Handling", test_num);
            reset_dut();

            @(negedge clk);
            cmd = 2'b11;

            @(posedge clk);
            #1;



            #1;




            check_outputs(data_out, 1, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sd_card_controller Testbench");
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
        input expected_error;
        input expected_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_error === (expected_error ^ error ^ expected_error) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, error=%b, ready=%b",
                         data_out, error, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, error=%b, ready=%b",
                         expected_data_out, expected_error, expected_ready);
                $display("  Got:      data_out=%h, error=%b, ready=%b",
                         data_out, error, ready);
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
        $dumpvars(0,clk, cmd, data_in, reset, data_out, error, ready);
    end

endmodule
