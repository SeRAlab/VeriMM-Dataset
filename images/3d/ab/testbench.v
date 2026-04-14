`timescale 1ns/1ps

module flash_memory_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] data_in;
    reg read_enable;
    reg write_enable;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory dut (
        .data_in(data_in),
        .read_enable(read_enable),
        .write_enable(write_enable),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Write and Read simultaneously", test_num);
        data_in = 5'h12;
        write_enable = 1;
        read_enable = 1;
        #10;
        #1;

        check_outputs(5'h12);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Write then Read separately", test_num);

        data_in = 5'h0A;
        write_enable = 1;
        read_enable = 0;
        #10;

        write_enable = 0;
        read_enable = 1;
        #10;
        #1;

        check_outputs(5'h0A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Output unchanged when WE and RE are low", test_num);

        write_enable = 0;
        read_enable = 0;
        data_in = 5'h1F;
        #10;
        #1;

        check_outputs(5'h0A);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: No write when write_enable is low", test_num);

        data_in = 5'h15;
        write_enable = 0;
        read_enable = 1;
        #10;

        #1;


        check_outputs(5'h0A);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Boundary value test (5'h1F)", test_num);
        data_in = 5'h1F;
        write_enable = 1;
        read_enable = 1;
        #10;
        #1;

        check_outputs(5'h1F);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Boundary value test (5'h00)", test_num);
        data_in = 5'h00;
        write_enable = 1;
        read_enable = 1;
        #10;
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Toggle RE while WE is low", test_num);

        data_in = 5'h05;
        write_enable = 1;
        read_enable = 0;
        #10;
        write_enable = 0;
        #10;

        read_enable = 1;
        #10;
        #1;

        check_outputs(5'h05);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("flash_memory Testbench");
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
        input [4:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
