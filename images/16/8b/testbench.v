`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] din;
    reg read_en;
    reg write_en;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .din(din),
        .read_en(read_en),
        .write_en(write_en),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        read_en = 0;
        forever #5 read_en = ~read_en;
    end

        task reset_dut;

        begin
            write_en = 0;
            din = 0;


            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %03d: Basic Write and Read (0xAAAA)", test_num);
            reset_dut();


            din = 16'hAAAA;
            write_en = 1;
            #10;
            write_en = 0;



            @(posedge read_en);
            #2;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %03d: Basic Write and Read (0x5555)", test_num);
            reset_dut();


            din = 16'h5555;
            write_en = 1;
            #10;
            write_en = 0;


            @(posedge read_en);
            #2;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %03d: Write All Ones (0xFFFF)", test_num);
            reset_dut();

            din = 16'hFFFF;
            write_en = 1;
            #10;
            write_en = 0;

            @(posedge read_en);
            #2;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %03d: Write All Zeros (0x0000)", test_num);
            reset_dut();

            din = 16'h0000;
            write_en = 1;
            #10;
            write_en = 0;

            @(posedge read_en);
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %03d: Data Persistence Check", test_num);
            reset_dut();


            din = 16'h1234;
            write_en = 1;
            #10;
            write_en = 0;


            din = 16'hFEDC;
            #10;


            @(posedge read_en);
            #2;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %03d: Overwrite Check", test_num);
            reset_dut();


            din = 16'hAAAA;
            write_en = 1;
            #10;


            din = 16'hBBBB;
            #10;
            write_en = 0;


            @(posedge read_en);
            #2;
            #1;

            check_outputs(16'hBBBB);
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
        input [15:0] expected_dout;
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
        $dumpvars(0,din, read_en, write_en, dout);
    end

endmodule
