`timescale 1ns/1ps

module register_file_tb;

    // Testbench signals (sequential circuit)
    reg read_en;
    reg [15:0] reg_addr;
    reg [7:0] write_data;
    reg write_en;
    wire [7:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_file dut (
        .read_en(read_en),
        .reg_addr(reg_addr),
        .write_data(write_data),
        .write_en(write_en),
        .read_data(read_data)
    );

        task reset_dut;

        begin
            read_en = 0;
            write_en = 0;
            reg_addr = 0;
            write_data = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            write_en = 1;
            reg_addr = 16'h0001;
            write_data = 8'hA5;
            #10;
            write_en = 0;


            read_en = 1;
            reg_addr = 16'h0001;
            #10;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address Check (0xFFFF)", test_num);
            reset_dut();


            write_en = 1;
            reg_addr = 16'hFFFF;
            write_data = 8'h5A;
            #10;
            write_en = 0;


            read_en = 1;
            reg_addr = 16'hFFFF;
            #10;

            #1;


            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Disable Check", test_num);
            reset_dut();


            write_en = 0;
            reg_addr = 16'h0005;
            write_data = 8'hFF;
            #10;


            read_en = 1;
            reg_addr = 16'h0005;
            #10;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multi-Register Persistence Check", test_num);
            reset_dut();


            write_en = 1;
            reg_addr = 16'h0010;
            write_data = 8'h11;
            #10;


            reg_addr = 16'h0020;
            write_data = 8'h22;
            #10;
            write_en = 0;


            read_en = 1;
            reg_addr = 16'h0010;
            #10;

            #1;


            check_outputs(8'h11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Register Overwrite Check", test_num);
            reset_dut();


            write_en = 1;
            reg_addr = 16'h000A;
            write_data = 8'hCC;
            #10;


            write_data = 8'hDD;
            #10;
            write_en = 0;


            read_en = 1;
            reg_addr = 16'h000A;
            #10;

            #1;


            check_outputs(8'hDD);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Read Enable Disable Check", test_num);
            reset_dut();


            write_en = 1;
            reg_addr = 16'h0007;
            write_data = 8'h77;
            #10;
            write_en = 0;



            read_en = 1;
            reg_addr = 16'h0007;
            #10;

            #1;


            check_outputs(8'h77);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_file Testbench");
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
        input [7:0] expected_read_data;
        begin
            if (expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: read_data=%h",
                         read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data=%h",
                         expected_read_data);
                $display("  Got:      read_data=%h",
                         read_data);
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
        $dumpvars(0,read_en, reg_addr, write_data, write_en, read_data);
    end

endmodule
