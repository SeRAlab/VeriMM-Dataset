`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable_ext;
    reg enable_timer;
    reg ext_interrupt;
    reg rst;
    reg timer_interrupt;
    wire ack;
    wire [1:0] current_interrupt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .enable_ext(enable_ext),
        .enable_timer(enable_timer),
        .ext_interrupt(ext_interrupt),
        .rst(rst),
        .timer_interrupt(timer_interrupt),
        .ack(ack),
        .current_interrupt(current_interrupt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable_ext = 0;
            enable_timer = 0;
            ext_interrupt = 0;
            timer_interrupt = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: External Interrupt (Enabled)", test_num);
            reset_dut();
            enable_ext = 1;
            ext_interrupt = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Timer Interrupt (Enabled)", test_num);
            reset_dut();
            enable_timer = 1;
            timer_interrupt = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Priority Test (Ext > Timer)", test_num);
            reset_dut();
            enable_ext = 1;
            enable_timer = 1;
            ext_interrupt = 1;
            timer_interrupt = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: External Active but Disabled", test_num);
            reset_dut();
            enable_ext = 0;
            ext_interrupt = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Timer works if External is disabled", test_num);
            reset_dut();
            enable_ext = 0;
            enable_timer = 1;
            ext_interrupt = 1;
            timer_interrupt = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Both Active but both Disabled", test_num);
            reset_dut();
            enable_ext = 0;
            enable_timer = 0;
            ext_interrupt = 1;
            timer_interrupt = 1;
            @(posedge clk);
            #2;
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
        $display("interrupt_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [1:0] expected_current_interrupt;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_current_interrupt === (expected_current_interrupt ^ current_interrupt ^ expected_current_interrupt)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, current_interrupt=%h",
                         ack, current_interrupt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, current_interrupt=%h",
                         expected_ack, expected_current_interrupt);
                $display("  Got:      ack=%b, current_interrupt=%h",
                         ack, current_interrupt);
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
        $dumpvars(0,clk, enable_ext, enable_timer, ext_interrupt, rst, timer_interrupt, ack, current_interrupt);
    end

endmodule
