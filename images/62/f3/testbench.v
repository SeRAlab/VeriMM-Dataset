`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [1023:0] data_entry;
    reg resetn;
    reg stall_exit;
    reg valid_entry;
    reg [9:0] workgroup_size;
    wire [1023:0] data_exit;
    wire stall_entry;
    wire valid_exit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data_entry(data_entry),
        .resetn(resetn),
        .stall_exit(stall_exit),
        .valid_entry(valid_entry),
        .workgroup_size(workgroup_size),
        .data_exit(data_exit),
        .stall_entry(stall_entry),
        .valid_exit(valid_exit)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            resetn = 0;
            clear_inputs();
            repeat (2) @(posedge clock);
            #1 resetn = 1;
            repeat (1) @(posedge clock);
        end
        endtask
    task clear_inputs;

        begin
            data_entry = 0;
            valid_entry = 0;
            stall_exit = 0;
            workgroup_size = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic Barrier Sync (Size 2)", test_num);
            reset_dut();

            workgroup_size = 10'd2;


            data_entry = 1024'hAAAA_BBBB;
            valid_entry = 1;
            @(posedge clock);
            while(stall_entry) @(posedge clock);
            #1;


            data_entry = 1024'hCCCC_DDDD;
            valid_entry = 1;
            @(posedge clock);
            while(stall_entry) @(posedge clock);
            #1;

            valid_entry = 0;

            #1;


            check_outputs(1024'hCCCC_DDDD, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Reset Mid-Operation", test_num);
            reset_dut();

            workgroup_size = 10'd5;


            repeat (3) begin
                valid_entry = 1;
                data_entry = $random;
                @(posedge clock);
                while(stall_entry) @(posedge clock);
                #1;
            end


            resetn = 0;
            @(posedge clock);
            #1 resetn = 1;


            #1;



            check_outputs(data_entry, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Exit Stall Handling", test_num);
            reset_dut();

            workgroup_size = 10'd1;
            stall_exit = 1;

            data_entry = 1024'hF0F0_F0F0;
            valid_entry = 1;
            @(posedge clock);
            #1;



            #1;




            check_outputs(1024'hF0F0_F0F0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Test Case %0d: Large Workgroup Size (10)", test_num);
            reset_dut();

            workgroup_size = 10'd10;

            for (i = 1; i <= 10; i = i + 1) begin
                valid_entry = 1;
                data_entry = i;
                @(posedge clock);
                while(stall_entry) @(posedge clock);
                #1;
                if (i < 10 && valid_exit == 1) begin
                    $display("FAIL: valid_exit high too early at count %0d", i);
                end
            end

            valid_entry = 0;
            #1;

            check_outputs(1024'd10, 1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [1023:0] expected_data_exit;
        input expected_stall_entry;
        input expected_valid_exit;
        begin
            if (expected_data_exit === (expected_data_exit ^ data_exit ^ expected_data_exit) &&
                expected_stall_entry === (expected_stall_entry ^ stall_entry ^ expected_stall_entry) &&
                expected_valid_exit === (expected_valid_exit ^ valid_exit ^ expected_valid_exit)) begin
                $display("PASS");
                $display("  Outputs: data_exit=%h, stall_entry=%b, valid_exit=%b",
                         data_exit, stall_entry, valid_exit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_exit=%h, stall_entry=%b, valid_exit=%b",
                         expected_data_exit, expected_stall_entry, expected_valid_exit);
                $display("  Got:      data_exit=%h, stall_entry=%b, valid_exit=%b",
                         data_exit, stall_entry, valid_exit);
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
        $dumpvars(0,clock, data_entry, resetn, stall_exit, valid_entry, workgroup_size, data_exit, stall_entry, valid_exit);
    end

endmodule
