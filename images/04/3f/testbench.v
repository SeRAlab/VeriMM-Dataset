`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cs_n;
    reg mosi;
    reg reset;
    wire miso;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .cs_n(cs_n),
        .mosi(mosi),
        .reset(reset),
        .miso(miso)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            cs_n = 1;
            mosi = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State and Idle Check (CS_N=1)", test_num);


            mosi = 1;
            #20;



            #1;




            check_outputs(1'bz);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write and Read Single Bit '1'", test_num);

            @(negedge clk);
            cs_n = 0;
            mosi = 1;

            @(posedge clk);
            #2;
            @(negedge clk);
            #2;

            #1;


            check_outputs(1'b1);
            cs_n = 1;
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write and Read Single Bit '0'", test_num);

            @(negedge clk);
            cs_n = 0;
            mosi = 0;

            @(posedge clk);
            #2;
            @(negedge clk);
            #2;

            #1;


            check_outputs(1'b0);
            cs_n = 1;
        end
        endtask

    task testcase004;

        integer i;
        reg [3:0] pattern;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 4-bit Sequence Pattern (1010)", test_num);

            pattern = 4'b1010;
            @(negedge clk);
            cs_n = 0;

            for(i = 3; i >= 0; i = i - 1) begin
                mosi = pattern[i];
                @(posedge clk);
                #2;
                @(negedge clk);
                #2;
            end


            #1;



            check_outputs(1'b0);
            cs_n = 1;
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Chip Select Disable Mid-Transaction", test_num);

            @(negedge clk);
            cs_n = 0;
            mosi = 1;
            @(posedge clk);
            #2;
            @(negedge clk);


            cs_n = 1;
            #10;


            #1;



            check_outputs(1'bz);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spi_controller Testbench");
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
        input expected_miso;
        begin
            if (expected_miso === (expected_miso ^ miso ^ expected_miso)) begin
                $display("PASS");
                $display("  Outputs: miso=%b",
                         miso);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: miso=%b",
                         expected_miso);
                $display("  Got:      miso=%b",
                         miso);
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
        $dumpvars(0,clk, cs_n, mosi, reset, miso);
    end

endmodule
