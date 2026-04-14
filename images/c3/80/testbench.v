`timescale 1ns/1ps

module memory_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] address;
    reg clock;
    reg [31:0] data_in;
    reg reset_n;
    reg write_en;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory dut (
        .address(address),
        .clock(clock),
        .data_in(data_in),
        .reset_n(reset_n),
        .write_en(write_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(posedge clock);
            reset_n = 0;
            write_en = 0;
            address = 0;
            data_in = 0;
            @(posedge clock);
            reset_n = 1;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Reset", test_num);
            reset_dut();


            #1;



            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Write and Read", test_num);
            reset_dut();


            @(posedge clock);
            write_en = 1;
            address = 5'd10;
            data_in = 32'hABCDE001;


            @(posedge clock);
            write_en = 0;
            address = 5'd10;


            @(posedge clock);
            #1;

            check_outputs(32'hABCDE001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Address Check", test_num);
            reset_dut();


            @(posedge clock);
            write_en = 1;
            address = 5'd0;
            data_in = 32'h11112222;


            @(posedge clock);
            write_en = 1;
            address = 5'd31;
            data_in = 32'h33334444;


            @(posedge clock);
            write_en = 0;
            address = 5'd31;

            @(posedge clock);
            #1;

            check_outputs(32'h33334444);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overwrite Check", test_num);
            reset_dut();


            @(posedge clock);
            write_en = 1;
            address = 5'd15;
            data_in = 32'hAAAAAAAA;


            @(posedge clock);
            write_en = 1;
            address = 5'd15;
            data_in = 32'h55555555;


            @(posedge clock);
            write_en = 0;
            address = 5'd15;

            @(posedge clock);
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initialization Check", test_num);
            reset_dut();


            @(posedge clock);
            write_en = 0;
            address = 5'd20;

            @(posedge clock);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Dominance", test_num);
            reset_dut();


            @(posedge clock);
            write_en = 1;
            address = 5'd7;
            data_in = 32'hFFFFFFFF;


            @(posedge clock);
            write_en = 0;
            address = 5'd7;
            @(posedge clock);


            reset_n = 0;
            @(posedge clock);


            #1;



            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequential Access", test_num);
            reset_dut();


            @(posedge clock);
            write_en = 1; address = 5'd1; data_in = 32'h1;

            @(posedge clock);
            write_en = 1; address = 5'd2; data_in = 32'h2;


            @(posedge clock);
            write_en = 0; address = 5'd1;
            @(posedge clock);



            write_en = 0; address = 5'd2;
            @(posedge clock);
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("memory Testbench");
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
        input [31:0] expected_data_out;
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
        $dumpvars(0,address, clock, data_in, reset_n, write_en, data_out);
    end

endmodule
