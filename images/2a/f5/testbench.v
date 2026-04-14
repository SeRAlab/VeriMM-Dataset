`timescale 1ns/1ps

module sd_card_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] command;
    reg reset;
    wire busy;
    wire [1:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_controller dut (
        .clk(clk),
        .command(command),
        .reset(reset),
        .busy(busy),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            command = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Power-on Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initialization Command", test_num);
            reset_dut();

            command = 2'b11;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Read Command", test_num);
            reset_dut();

            command = 2'b01;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Command", test_num);
            reset_dut();

            command = 2'b10;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset during Operation", test_num);
            reset_dut();

            command = 2'b01;
            @(posedge clk);
            #1;


            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Idle/No Command", test_num);
            reset_dut();

            command = 2'b00;
            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 2'b00);
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
        input expected_busy;
        input [1:0] expected_status;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, status=%h",
                         busy, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, status=%h",
                         expected_busy, expected_status);
                $display("  Got:      busy=%b, status=%h",
                         busy, status);
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
        $dumpvars(0,clk, command, reset, busy, status);
    end

endmodule
