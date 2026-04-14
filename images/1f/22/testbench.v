`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] DIN;
    reg READ;
    reg WRITE;
    wire [3:0] DOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .CLK(CLK),
        .DIN(DIN),
        .READ(READ),
        .WRITE(WRITE),
        .DOUT(DOUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            READ = 0;
            WRITE = 0;
            DIN = 4'h0;
            @(negedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic Write and Read", test_num);
            reset_dut();


            WRITE = 1;
            DIN = 4'hA;
            @(posedge CLK);


            WRITE = 0;
            READ = 1;
            @(posedge CLK);

            #1;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Overwriting data", test_num);
            reset_dut();


            WRITE = 1;
            DIN = 4'h5;
            @(posedge CLK);


            DIN = 4'hF;
            @(posedge CLK);


            WRITE = 0;
            READ = 1;
            @(posedge CLK);

            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Simultaneous Read and Write", test_num);
            reset_dut();


            WRITE = 1;
            READ = 1;
            DIN = 4'h7;
            @(posedge CLK);

            #1;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Data retention check", test_num);
            reset_dut();


            WRITE = 1;
            DIN = 4'h3;
            @(posedge CLK);


            WRITE = 0;
            READ = 0;
            DIN = 4'h0;
            @(posedge CLK);
            @(posedge CLK);


            READ = 1;
            @(posedge CLK);

            #1;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Write Enable signal check", test_num);
            reset_dut();


            WRITE = 1;
            DIN = 4'h1;
            @(posedge CLK);


            WRITE = 0;
            DIN = 4'hE;
            @(posedge CLK);


            READ = 1;
            @(posedge CLK);

            #1;
            #1;

            check_outputs(4'h1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        input [3:0] expected_DOUT;
        begin
            if (expected_DOUT === (expected_DOUT ^ DOUT ^ expected_DOUT)) begin
                $display("PASS");
                $display("  Outputs: DOUT=%h",
                         DOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOUT=%h",
                         expected_DOUT);
                $display("  Got:      DOUT=%h",
                         DOUT);
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
        $dumpvars(0,CLK, DIN, READ, WRITE, DOUT);
    end

endmodule
