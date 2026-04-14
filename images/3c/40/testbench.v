`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg addr;
    reg [7:0] data_in;
    reg read_en;
    reg write_en;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_Cell dut (
        .addr(addr),
        .data_in(data_in),
        .read_en(read_en),
        .write_en(write_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        read_en = 0;
        forever #5 read_en = ~read_en;
    end

        task reset_dut;

        begin
            addr = 0;
            data_in = 8'h00;
            write_en = 0;

            @(negedge read_en);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write and Read Address 0", test_num);


            addr = 0;
            data_in = 8'hAA;
            write_en = 1;
            @(posedge read_en);
            #2;
            write_en = 0;


            #1;



            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write and Read Address 1", test_num);


            addr = 1;
            data_in = 8'h55;
            write_en = 1;
            @(posedge read_en);
            #2;
            write_en = 0;


            #1;



            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Address isolation check", test_num);


            addr = 0;
            data_in = 8'h11;
            write_en = 1;
            @(posedge read_en);
            #5;


            addr = 1;
            data_in = 8'h22;
            write_en = 1;
            @(posedge read_en);
            #5;


            write_en = 0;
            addr = 0;
            @(posedge read_en);
            #2;


            #1;



            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite check", test_num);


            addr = 0;
            data_in = 8'hFF;
            write_en = 1;
            @(posedge read_en);
            #5;


            data_in = 8'h12;
            @(posedge read_en);
            #5;

            write_en = 0;
            @(posedge read_en);
            #2;


            #1;



            check_outputs(8'h12);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary check (All Zeros)", test_num);

            addr = 1;
            data_in = 8'h00;
            write_en = 1;
            @(posedge read_en);
            #2;
            write_en = 0;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary check (All Ones)", test_num);

            addr = 0;
            data_in = 8'hFF;
            write_en = 1;
            @(posedge read_en);
            #2;
            write_en = 0;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_Cell Testbench");
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
        $dumpvars(0,addr, data_in, read_en, write_en, data_out);
    end

endmodule
