`timescale 1ns/1ps

module eeprom_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    reg set;
    wire data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom_cell dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .set(set),
        .data(data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 1'b1;
            reset  = 1'b1;
            set    = 1'b0;
            @(posedge clk);
            #1;
            enable = 1'b0;
            reset  = 1'b0;
            set    = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Reset/Clear Operation", test_num);
            reset_dut();

            enable = 1'b1;
            reset  = 1'b1;
            set    = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Set (Write 1) Operation", test_num);
            reset_dut();
            enable = 1'b1;
            set    = 1'b1;
            reset  = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Write Enable Inhibition (Enable=0)", test_num);
            reset_dut();
            enable = 1'b0;
            set    = 1'b1;
            reset  = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Data Retention", test_num);
            reset_dut();

            enable = 1'b1;
            set    = 1'b1;
            reset  = 1'b0;
            @(posedge clk);
            #1;

            enable = 1'b0;
            set    = 1'b0;
            reset  = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Transition Set to Reset", test_num);
            reset_dut();

            enable = 1'b1;
            set    = 1'b1;
            reset  = 1'b0;
            @(posedge clk);
            #1;

            enable = 1'b1;
            set    = 1'b0;
            reset  = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Stability Over Multiple Cycles", test_num);
            reset_dut();

            enable = 1'b1;
            set    = 1'b1;
            reset  = 1'b0;
            @(posedge clk);
            #1;

            enable = 1'b0;
            set    = 1'b0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eeprom_cell Testbench");
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
        input expected_data;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: data=%b",
                         data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%b",
                         expected_data);
                $display("  Got:      data=%b",
                         data);
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
        $dumpvars(0,clk, enable, reset, set, data);
    end

endmodule
