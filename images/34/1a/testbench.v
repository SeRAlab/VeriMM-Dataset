`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg READ;
    reg WRITE;
    reg [7:0] data_in;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .CLK(CLK),
        .READ(READ),
        .WRITE(WRITE),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            READ <= 0;
            WRITE <= 0;
            data_in <= 8'h00;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Basic Write and Read (0xAA)", test_num);
            reset_dut();


            WRITE = 1;
            data_in = 8'hAA;
            @(posedge CLK);
            #1;
            WRITE = 0;


            READ = 1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'hAA);
            READ = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Basic Write and Read (0x55)", test_num);
            reset_dut();

            WRITE = 1;
            data_in = 8'h55;
            @(posedge CLK);
            #1;
            WRITE = 0;

            READ = 1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h55);
            READ = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Data Persistence Check", test_num);
            reset_dut();


            WRITE = 1;
            data_in = 8'hBE;
            @(posedge CLK);
            #1;
            WRITE = 0;


            repeat(3) @(posedge CLK);
            #1;


            READ = 1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'hBE);
            READ = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Overwrite Data Check", test_num);
            reset_dut();


            WRITE = 1;
            data_in = 8'h11;
            @(posedge CLK);
            #1;


            data_in = 8'h22;
            @(posedge CLK);
            #1;
            WRITE = 0;


            READ = 1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h22);
            READ = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Boundary Value 0xFF", test_num);
            reset_dut();

            WRITE = 1;
            data_in = 8'hFF;
            @(posedge CLK);
            #1;
            WRITE = 0;

            READ = 1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'hFF);
            READ = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Boundary Value 0x00", test_num);
            reset_dut();

            WRITE = 1;
            data_in = 8'h00;
            @(posedge CLK);
            #1;
            WRITE = 0;

            READ = 1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h00);
            READ = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Simultaneous Read and Write", test_num);
            reset_dut();


            WRITE = 1;
            data_in = 8'h12;
            @(posedge CLK);
            #1;


            WRITE = 1;
            READ = 1;
            data_in = 8'h34;
            @(posedge CLK);
            #1;



            #1;




            check_outputs(8'h34);
            WRITE = 0;
            READ = 0;
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %03d: Read Disable Output Check", test_num);
            reset_dut();

            WRITE = 1;
            data_in = 8'h77;
            @(posedge CLK);
            #1;
            WRITE = 0;
            READ = 0;

            @(posedge CLK);
            #1;


            #1;



            check_outputs(8'h00);
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
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,CLK, READ, WRITE, data_in, data_out);
    end

endmodule
