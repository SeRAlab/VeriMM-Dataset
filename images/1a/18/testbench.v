`timescale 1ns/1ps

module GPIO_Controller_tb;

    // Testbench signals (sequential circuit)
    reg ENABLE;
    reg [3:0] GPIO_IN;
    reg RST;
    wire [3:0] GPIO_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    GPIO_Controller dut (
        .ENABLE(ENABLE),
        .GPIO_IN(GPIO_IN),
        .RST(RST),
        .GPIO_OUT(GPIO_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        ENABLE = 0;
        forever #5 ENABLE = ~ENABLE;
    end

        task reset_dut;

        begin
            RST = 1;
            GPIO_IN = 4'b0000;
            #10;
            RST = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial Reset", test_num);
            reset_dut();
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Follow Input (ENABLE=1)", test_num);
            reset_dut();


            @(posedge ENABLE);
            GPIO_IN = 4'b1010;
            #2;

            #1;


            check_outputs(4'b1010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Latch/Hold Value (ENABLE=0)", test_num);
            reset_dut();


            @(posedge ENABLE);
            GPIO_IN = 4'b0111;
            #2;


            @(negedge ENABLE);
            #2;
            GPIO_IN = 4'b1111;
            #2;

            #1;


            check_outputs(4'b0111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple Input Changes", test_num);
            reset_dut();

            @(posedge ENABLE);
            GPIO_IN = 4'b0001; #1;
            GPIO_IN = 4'b0010; #1;
            GPIO_IN = 4'b0100; #1;
            GPIO_IN = 4'b1000; #1;

            #1;


            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Priority over Enable", test_num);
            reset_dut();

            @(posedge ENABLE);
            GPIO_IN = 4'b1111;
            #2;
            RST = 1;
            #2;

            #1;


            check_outputs(4'b0000);
            RST = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Long Term Hold", test_num);
            reset_dut();

            @(posedge ENABLE);
            GPIO_IN = 4'b0101;
            #2;
            @(negedge ENABLE);


            repeat(4) @(posedge ENABLE);

            @(negedge ENABLE);
            GPIO_IN = 4'b0000;
            #2;

            #1;


            check_outputs(4'b0101);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("GPIO_Controller Testbench");
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
        input [3:0] expected_GPIO_OUT;
        begin
            if (expected_GPIO_OUT === (expected_GPIO_OUT ^ GPIO_OUT ^ expected_GPIO_OUT)) begin
                $display("PASS");
                $display("  Outputs: GPIO_OUT=%h",
                         GPIO_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GPIO_OUT=%h",
                         expected_GPIO_OUT);
                $display("  Got:      GPIO_OUT=%h",
                         GPIO_OUT);
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
        $dumpvars(0,ENABLE, GPIO_IN, RST, GPIO_OUT);
    end

endmodule
