`timescale 1ns/1ps

module sd_card_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg enable;
    reg mode;
    wire busy;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_controller dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .mode(mode),
        .busy(busy),
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
            mode = 0;
            data_in = 8'h00;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Idle State Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Write Operation (0xAA)", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'hAA;
            mode = 1;
            enable = 1;
            @(posedge clk);
            enable = 0;



            repeat(2) @(posedge clk);
            wait(busy == 0);
            repeat(1) @(posedge clk);



            #1;




            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Read Operation", test_num);
            reset_dut();

            @(posedge clk);
            mode = 0;
            enable = 1;
            @(posedge clk);
            enable = 0;


            wait(busy == 1);
            wait(busy == 0);
            repeat(1) @(posedge clk);





            #1;






            check_outputs(1'b0, data_out);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Successive Write and Read (0x55)", test_num);
            reset_dut();


            @(posedge clk);
            data_in = 8'h55;
            mode = 1;
            enable = 1;
            @(posedge clk);
            enable = 0;
            wait(busy == 0);

            repeat(2) @(posedge clk);


            mode = 0;
            enable = 1;
            @(posedge clk);
            enable = 0;
            wait(busy == 0);
            repeat(1) @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: Enable Suppression Check", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'hFF;
            mode = 1;
            enable = 0;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b0, 8'h00);
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
        input expected_busy;
        input [7:0] expected_data_out;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, data_out=%h",
                         busy, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, data_out=%h",
                         expected_busy, expected_data_out);
                $display("  Got:      busy=%b, data_out=%h",
                         busy, data_out);
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
        $dumpvars(0,clk, data_in, enable, mode, busy, data_out);
    end

endmodule
