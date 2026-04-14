`timescale 1ns/1ps

module sd_card_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cmd;
    reg [7:0] data_in;
    reg rst;
    wire ack;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_controller dut (
        .clk(clk),
        .cmd(cmd),
        .data_in(data_in),
        .rst(rst),
        .ack(ack),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            cmd = 0;
            data_in = 8'h00;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            $display("Reset completed.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic Write Operation", test_num);
            reset_dut();


            cmd = 1;
            data_in = 8'hA5;
            @(posedge clk);
            cmd = 0;


            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic Read Operation", test_num);
            reset_dut();


            cmd = 0;
            data_in = 8'h00;
            @(posedge clk);


            repeat(5) @(posedge clk);



            #1;




            check_outputs(1'b0, 8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Successive Write Operations", test_num);
            reset_dut();


            cmd = 1;
            data_in = 8'h11;
            @(posedge clk);
            cmd = 0;
            repeat(4) @(posedge clk);


            cmd = 1;
            data_in = 8'h22;
            @(posedge clk);
            cmd = 0;
            repeat(4) @(posedge clk);


            #1;



            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset State Verification", test_num);


            cmd = 1;
            data_in = 8'hFF;
            repeat(2) @(posedge clk);


            reset_dut();


            #1;



            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Data Integrity Read", test_num);
            reset_dut();


            cmd = 0;
            @(posedge clk);


            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, 8'hAA);
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
        input expected_ack;
        input [7:0] expected_data_out;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, data_out=%h",
                         ack, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, data_out=%h",
                         expected_ack, expected_data_out);
                $display("  Got:      ack=%b, data_out=%h",
                         ack, data_out);
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
        $dumpvars(0,clk, cmd, data_in, rst, ack, data_out);
    end

endmodule
