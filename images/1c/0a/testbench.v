`timescale 1ns/1ps

module eeprom_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg re;
    reg we;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom dut (
        .clk(clk),
        .din(din),
        .re(re),
        .we(we),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            re = 0;
            din = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Write and Read (0xA5)", test_num);
            reset_dut();

            we = 1;
            din = 8'hA5;
            @(posedge clk);
            #1;
            we = 0;

            re = 1;
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Overwrite Data (0xA5 -> 0x5A)", test_num);
            reset_dut();

            we = 1; din = 8'hA5;
            @(posedge clk); #1;

            we = 1; din = 8'h5A;
            @(posedge clk); #1;
            we = 0;

            re = 1;
            #2;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Verify No Write when WE is low", test_num);
            reset_dut();

            we = 1; din = 8'h11;
            @(posedge clk); #1;

            we = 0; din = 8'h22;
            @(posedge clk); #1;

            re = 1;
            #2;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Verify Data Persistence over multiple cycles", test_num);
            reset_dut();

            we = 1; din = 8'hBC;
            @(posedge clk); #1;
            we = 0;

            repeat(5) @(posedge clk);
            #1;

            re = 1;
            #2;
            #1;

            check_outputs(8'hBC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Boundary Test 0x00", test_num);
            reset_dut();
            we = 1; din = 8'h00;
            @(posedge clk); #1;
            we = 0; re = 1;
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Boundary Test 0xFF", test_num);
            reset_dut();
            we = 1; din = 8'hFF;
            @(posedge clk); #1;
            we = 0; re = 1;
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Toggle Read Enable", test_num);
            reset_dut();
            we = 1; din = 8'h33;
            @(posedge clk); #1;
            we = 0;
            re = 0; #5;
            re = 1; #2;
            #1;

            check_outputs(8'h33);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eeprom Testbench");
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
        input [7:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,clk, din, re, we, dout);
    end

endmodule
