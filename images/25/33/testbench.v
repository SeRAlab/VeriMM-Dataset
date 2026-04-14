`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] pin_select;
    reg set_clear;
    wire [4:0] gpio_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .pin_select(pin_select),
        .set_clear(set_clear),
        .gpio_state(gpio_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        integer i;
        begin


            for (i = 0; i < 5; i = i + 1) begin
                pin_select = i;
                set_clear = 0;
                @(posedge clk);
            end
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Set Pin 0", test_num);
            reset_dut();

            pin_select = 5'd0;
            set_clear = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'b00001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Set Pin 4", test_num);
            reset_dut();

            pin_select = 5'd4;
            set_clear = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'b10000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Set Pins 0, 2, and 4", test_num);
            reset_dut();


            pin_select = 5'd0; set_clear = 1'b1; @(posedge clk);

            pin_select = 5'd2; set_clear = 1'b1; @(posedge clk);

            pin_select = 5'd4; set_clear = 1'b1; @(posedge clk);
            #1;

            #1;


            check_outputs(5'b10101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Set and Clear Pin 1", test_num);
            reset_dut();


            pin_select = 5'd1; set_clear = 1'b1; @(posedge clk);

            pin_select = 5'd1; set_clear = 1'b0; @(posedge clk);
            #1;

            #1;


            check_outputs(5'b00000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Clear Pin 3 (already low)", test_num);
            reset_dut();

            pin_select = 5'd3;
            set_clear = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'b00000);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Set All Pins (0-4)", test_num);
            reset_dut();

            for (i = 0; i < 5; i = i + 1) begin
                pin_select = i;
                set_clear = 1'b1;
                @(posedge clk);
            end
            #1;

            #1;


            check_outputs(5'b11111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex Set/Clear sequence", test_num);
            reset_dut();


            pin_select = 5'd0; set_clear = 1'b1; @(posedge clk);
            pin_select = 5'd1; set_clear = 1'b1; @(posedge clk);
            pin_select = 5'd2; set_clear = 1'b1; @(posedge clk);

            pin_select = 5'd1; set_clear = 1'b0; @(posedge clk);

            pin_select = 5'd4; set_clear = 1'b1; @(posedge clk);
            #1;

            #1;


            check_outputs(5'b10101);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gpio_controller Testbench");
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
        input [4:0] expected_gpio_state;
        begin
            if (expected_gpio_state === (expected_gpio_state ^ gpio_state ^ expected_gpio_state)) begin
                $display("PASS");
                $display("  Outputs: gpio_state=%h",
                         gpio_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gpio_state=%h",
                         expected_gpio_state);
                $display("  Got:      gpio_state=%h",
                         gpio_state);
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
        $dumpvars(0,clk, pin_select, set_clear, gpio_state);
    end

endmodule
