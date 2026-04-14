`timescale 1ns/1ps

module r_FAULT_STATUS_MASK_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_data;
    reg reset;
    reg wenb;
    wire [7:0] reg_0x15;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    r_FAULT_STATUS_MASK dut (
        .clk(clk),
        .in_data(in_data),
        .reset(reset),
        .wenb(wenb),
        .reg_0x15(reg_0x15)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in_data = 8'h00;
            wenb = 1;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset functionality", test_num);
            reset_dut();


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic write operation (wenb=0)", test_num);
            reset_dut();
            in_data = 8'hA5;
            wenb = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write inhibit (wenb=1)", test_num);
            reset_dut();


            in_data = 8'h55;
            wenb = 0;
            @(posedge clk);
            #2;


            in_data = 8'hAA;
            wenb = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential write operations", test_num);
            reset_dut();

            wenb = 0;
            in_data = 8'h11;
            @(posedge clk);
            #2;
            in_data = 8'h22;
            @(posedge clk);
            #2;
            in_data = 8'h33;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write boundary value 0xFF", test_num);
            reset_dut();

            in_data = 8'hFF;
            wenb = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset priority over wenb", test_num);
            reset_dut();


            in_data = 8'hCC;
            wenb = 0;
            @(posedge clk);
            #2;


            reset = 1;
            @(posedge clk);
            #2;
            reset = 0;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write and then toggle wenb", test_num);
            reset_dut();


            in_data = 8'hDE;
            wenb = 0;
            @(posedge clk);
            #2;


            wenb = 1;
            in_data = 8'hAD;
            @(posedge clk);
            #2;


            wenb = 0;
            in_data = 8'hBE;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hBE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("r_FAULT_STATUS_MASK Testbench");
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
        input [7:0] expected_reg_0x15;
        begin
            if (expected_reg_0x15 === (expected_reg_0x15 ^ reg_0x15 ^ expected_reg_0x15)) begin
                $display("PASS");
                $display("  Outputs: reg_0x15=%h",
                         reg_0x15);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_0x15=%h",
                         expected_reg_0x15);
                $display("  Got:      reg_0x15=%h",
                         reg_0x15);
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
        $dumpvars(0,clk, in_data, reset, wenb, reg_0x15);
    end

endmodule
